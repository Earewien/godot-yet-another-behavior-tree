@tool
extends BTLeaf
class_name BTActionBlackboardDelete
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btactionblackboarddelete.png")

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

func tick(actor:Node2D, blackboard:BTBlackboard) -> int:
    blackboard.delete_data(blackboard_key)
    return BTTickResult.SUCCESS

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
