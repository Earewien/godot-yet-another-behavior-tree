@tool
extends BTLeaf
class_name BTActionBlackboardSet
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btactionblackboardset.png")

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export var blackboard_key:String = "" :
    set(value):
        blackboard_key = value
        update_configuration_warnings()

@export_multiline var expression:String = "" :
    set(value):
        expression = value
        update_configuration_warnings()

@export var can_overwrite_value:bool = false

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

var _parsed_compared_value:Variant

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

func tick(actor:Node2D, blackboard:BTBlackboard) -> int:
    if can_overwrite_value or not blackboard.has_data(blackboard_key):
        var value:Variant = _execute_expression(actor, blackboard)
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
    return _parse_expression() != null

func _parse_expression() -> Expression:
    var expr:Expression = Expression.new()
    var parse_code:int = expr.parse(expression, ["actor", "blackboard"])
    if parse_code != OK:
        push_error("Unable to parse expression '%s' : %s" % [expression, expr.get_error_text()])
        return null
    return expr

func _execute_expression(actor:Node2D, blackboard:BTBlackboard) -> Variant:
    var result:Variant = null
    var expr:Expression = _parse_expression()
    if expr != null:
        result = expr.execute([actor, blackboard], self, true)
        if expr.has_execute_failed():
            result = null
            push_error("Unable to execute expression '%s' : %s" % [expression, expr.get_error_text()])
    return result
