@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btconditionblackboardkeyexists.png")
class_name BTConditionBlackboardKeyExists
extends BTLeaf


## The blackboard key exists condition node is a [i]leaf[/i] node. It returns [i]success[/i] if a certain key
## is present in the tree blackboard during its execution, [i]failure[/i] otherwise. This node operates in the blackboard
## [i]default namespace[/i].


#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

## Name of the key that must exists in the blackboard, in [i]default namespace[/i]
@export var blackboard_key:String = "" :
    set(value):
        blackboard_key = value

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _get_configuration_warnings() -> PackedStringArray:
    var warnings:PackedStringArray = []
    warnings.append_array(super._get_configuration_warnings())
    if not _blackboard_key_is_set():
        warnings.append("Blackboard key must be set")
    return warnings

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func tick(actor:Node, blackboard:BTBlackboard) -> int:
    var result:int = BTTickResult.FAILURE
    if blackboard.has_data(blackboard_key):
        result = BTTickResult.SUCCESS
    return result

#------------------------------------------
# Fonctions privées
#------------------------------------------

func is_valid() -> bool:
    var is_valid:bool = super.is_valid()
    if is_valid:
        is_valid = _blackboard_key_is_set()
    return is_valid

func _blackboard_key_is_set() -> bool:
    return blackboard_key != null and not blackboard_key.is_empty()

