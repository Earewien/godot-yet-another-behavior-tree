@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btactionblackboardset.png")
class_name BTActionBlackboardSet
extends BTLeaf


## The blackboard set action node is a [i]leaf[/i] node. It allows to set a value in the blackboard.
## Its execution always returns [i]success[/i]. This node operates in the blackboard [i]default namespace[/i].


#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

## Name of the key that must be set, in [i]default namespace[/i]
@export var blackboard_key:String = "" :
    set(value):
        blackboard_key = value
        update_configuration_warnings()

## An expression representing the value to associated to the given key. The expression will be evaluated by
## Godot Engine during child execution. It should be simple. See [url=https://docs.godotengine.org/en/latest/classes/class_expression.html]Godot Expression[/url]
## for details. In expression, user has access to two predefined variables:[br]
##  - [code]actor[/code]: the node the tree is describing action for,[br]
##  - [code]blackboard[/code]: the tree blackboard,[br]
##  - [code]delta[/code]: the [i]_process[/i] or [i]_physics_process[/i] delta value, as a [code]float[/code].
@export_multiline var expression:String = "" :
    set(value):
        if value != expression:
            expression = value
            _update_expression()
            update_configuration_warnings()

## Indicates if the value must be overwritten if it already exists or not
@export var can_overwrite_value:bool = false

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

var _expression:BTExpression = BTExpression.new()

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _get_configuration_warnings() -> PackedStringArray:
    var warnings:PackedStringArray = []
    warnings.append_array(super._get_configuration_warnings())
    if not _blackboard_key_is_set():
        warnings.append("Blackboard key must be set")
    if not _expression_key_is_set():
        warnings.append("Expression must be set")
    if not _expression_is_valid():
        warnings.append("Expression is not valid")
    return warnings

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func tick(actor:Node, blackboard:BTBlackboard) -> int:
    if can_overwrite_value or not blackboard.has_data(blackboard_key):
        var value:Variant = _expression.evaluate(actor, blackboard)
        blackboard.set_data(blackboard_key, value)
    return BTTickResult.SUCCESS

#------------------------------------------
# Fonctions privées
#------------------------------------------

func is_valid() -> bool:
    var is_valid:bool = super.is_valid()
    if is_valid:
        is_valid = _blackboard_key_is_set()
    if is_valid:
        is_valid = _expression_key_is_set()
    return is_valid

func _blackboard_key_is_set() -> bool:
    return blackboard_key != null and not blackboard_key.is_empty()

func _expression_key_is_set() -> bool:
    return expression != null and not expression.is_empty()

func _expression_is_valid() -> bool:
    return _expression.is_valid()

func _update_expression() -> void:
    _expression.expression = expression
