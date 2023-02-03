@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btconditioncallable.png")
class_name BTConditionCallable
extends BTLeaf


## The callable condition node is a [i]leaf[/i] node. The node calls a function from an object that has been
## parametrized to check for a condition. It can also pass arguments to this function. Its result is the function
## result, meaning that specified function must returns a [code]bool[/code] value. This nodes returns
## [i]success[/i] if function call returned [code]true[/code], and [i]failure[/i] if function call returned [code]false[/code].


#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

## Path to the node that contains the function to call
@export var method_owner_path:NodePath:
    set(value):
        method_owner_path = value
        _update_method_owner_from_path()
        update_configuration_warnings()

## Name of the function to call in the [i]method owner node[i]
@export var method_name:String = "":
    set(value):
        method_name = value
        update_configuration_warnings()

## Array of arguments to pass when calling the function. Arguments are expressions that will
## be evaluated by Godot Engine at runtime to produce the desired value. See [url=https://docs.godotengine.org/en/latest/classes/class_expression.html]Godot Expression[/url]
## for details. In expression, user has access to two predefined variables:[br]
##  - [code]actor[/code]: the node the tree is describing action for,[br]
##  - [code]blackboard[/code]: the tree blackboard,[br]
##  - [code]delta[/code]: the [i]_process[/i] or [i]_physics_process[/i] delta value, as a [code]float[/code].[br]
## Number and types of arguments must match function prototype, or an error will occurs at runtime.
@export var method_arguments:Array[String] = []

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

var _method_owner:Node
var _cached_method_arguments:Array[String] = []
var _argument_expression:Array[BTExpression] = []

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _ready() -> void:
    _update_method_owner_from_path()
    _update_argument_expressions()

func _get_configuration_warnings() -> PackedStringArray:
    var warnings:PackedStringArray = []
    warnings.append_array(super._get_configuration_warnings())
    if not _check_method_owner_validity():
        warnings.append("Method owner must be set")
    if not _check_method_name_validity():
        warnings.append("Method name must be set")
    return warnings

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func tick(actor:Node, blackboard:BTBlackboard) -> int:
    _update_argument_expressions()
    var arguments:Array[Variant] = _argument_expression.map(func(expr):return expr.evaluate(actor, blackboard))
    var result:bool = _method_owner.callv(method_name, arguments)
    return BTTickResult.SUCCESS if result else BTTickResult.FAILURE

#------------------------------------------
# Fonctions privées
#------------------------------------------

func is_valid() -> bool:
    return _check_method_owner_validity() and _check_method_name_validity()

func _check_method_owner_validity() -> bool:
    var is_valid:bool = method_owner_path != null and not method_owner_path.is_empty()
    if is_valid:
        _update_method_owner_from_path()
        is_valid = _method_owner != null and is_instance_valid(_method_owner)
    return is_valid

func _check_method_name_validity() -> bool:
    return method_name != null and not method_name.is_empty()

func _update_method_owner_from_path() -> void:
    _method_owner = get_node_or_null(method_owner_path)
    if not is_instance_valid(_method_owner) and is_inside_tree():
        # Fallback : si le chemin donné n'était pas relatif à la scene courante, on le check en absolu
        _method_owner = get_tree().current_scene.get_node_or_null(method_owner_path)

func _update_argument_expressions() -> void:
    if _cached_method_arguments != method_arguments:
        _cached_method_arguments = Array(method_arguments)
        _argument_expression.clear()
        for expr in _cached_method_arguments:
            var btexpression:BTExpression = BTExpression.new()
            btexpression.expression = expr
            _argument_expression.append(btexpression)
