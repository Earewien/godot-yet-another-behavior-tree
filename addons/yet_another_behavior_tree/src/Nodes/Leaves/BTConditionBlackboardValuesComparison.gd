@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btconditionblackboardvaluescomparison.png")
class_name BTConditionBlackboardValuesComparison
extends BTLeaf


## The blackboard values comparison condition node is a [i]leaf[/i] node. It returns [i]success[/i] both values
## represented by specified keys returns true when compared using the given operator. This node operates in the blackboard
## [i]default namespace[/i].


enum Operator {
    EQUAL = 1,
    NOT_EQUAL = 2,
    LOWER = 3,
    LOWER_OR_EQUAL = 4,
    GREATER = 5,
    GREATER_OR_EQUAL = 6
}

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

## Name of the key that old the first value to compare, in [i]default namespace[/i]
@export var first_operand_blackboard_key:String = "" :
    set(value):
        first_operand_blackboard_key = value
        update_configuration_warnings()

## Operator used to compare values
@export_enum("EQUAL:1", "NOT_EQUAL:2", "LOWER:3", "LOWER_OR_EQUAL:4", "GREATER:5", "GREATER_OR_EQUAL:6") var operator:int = 0

## Name of the key that old the second value to compare, [i]default namespace[/i]
@export var second_operand_blackboard_key:String = "" :
    set(value):
        second_operand_blackboard_key = value
        update_configuration_warnings()

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
    if not _blackboard_keys_are_set():
        warnings.append("Blackboard keys must be set")
    return warnings

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func tick(actor:Node, blackboard:BTBlackboard) -> int:
    var result:int = BTTickResult.FAILURE

    var first_operand:Variant = blackboard.get_data(first_operand_blackboard_key)
    var second_operand:Variant = blackboard.get_data(second_operand_blackboard_key)
    if first_operand != null and second_operand != null:
        var compare_result:bool = false
        match(operator):
            Operator.EQUAL:
                compare_result = first_operand == second_operand
            Operator.NOT_EQUAL:
                compare_result = first_operand != second_operand
            Operator.LOWER:
                compare_result = first_operand < second_operand
            Operator.LOWER_OR_EQUAL:
                compare_result = first_operand <= second_operand
            Operator.GREATER:
                compare_result = first_operand > second_operand
            Operator.GREATER_OR_EQUAL:
                compare_result = first_operand >= second_operand
        if compare_result:
            return BTTickResult.SUCCESS
    return result

#------------------------------------------
# Fonctions privées
#------------------------------------------

func is_valid() -> bool:
    var is_valid:bool = super.is_valid()
    if is_valid:
        is_valid = _blackboard_keys_are_set()
    return is_valid

func _blackboard_keys_are_set() -> bool:
    return first_operand_blackboard_key != null and not first_operand_blackboard_key.is_empty() and second_operand_blackboard_key != null and not second_operand_blackboard_key.is_empty()

