@tool
extends BTLeaf
class_name BTConditionCallable
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btconditioncallable.png")

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export var method_owner_path:NodePath:
    set(value):
        method_owner_path = value
        _update_method_owner_from_path()
        update_configuration_warnings()

@export var method_name:String = "":
    set(value):
        method_name = value
        update_configuration_warnings()

@export var method_arguments:Array[String] = []

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

var _method_owner:Node

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _ready() -> void:
    _update_method_owner_from_path()

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

func tick(actor:Node2D, blackboard:BTBlackboard) -> int:
    var arguments:Array[Variant] = method_arguments.map(func(e): return _execute_expression(e, actor, blackboard))
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

func _parse_expression(string_expr:String) -> Expression:
    var expr:Expression = Expression.new()
    var parse_code:int = expr.parse(string_expr, ["actor", "blackboard"])
    if parse_code != OK:
        push_error("Unable to parse expression '%s' : %s" % [string_expr, expr.get_error_text()])
        return null
    return expr

func _execute_expression(string_expr:String, actor:Node2D, blackboard:BTBlackboard) -> Variant:
    var result:Variant = null
    var expr:Expression = _parse_expression(string_expr)
    if expr != null:
        result = expr.execute([actor, blackboard], self, true)
        if expr.has_execute_failed():
            result = null
            push_error("Unable to execute expression '%s' : %s" % [string_expr, expr.get_error_text()])
    return result
