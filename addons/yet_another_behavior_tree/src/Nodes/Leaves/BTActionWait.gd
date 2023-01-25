@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btactionwait.png")
extends BTLeaf
class_name BTActionWait

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export var wait_time_ms:int = 1_000

@export var random_deviation_ms:int = 0

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

var _current_time_ms:float = 0
var _time_to_reach_ms:int

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func tick(actor:Node, blackboard:BTBlackboard) -> int:
    _current_time_ms += blackboard.get_delta() * 1_000
    if _current_time_ms <= _time_to_reach_ms:
        return BTTickResult.RUNNING
    return BTTickResult.SUCCESS

func start(blackboard:BTBlackboard) -> void:
    _current_time_ms = 0
    _time_to_reach_ms = wait_time_ms
    if random_deviation_ms != 0:
        _time_to_reach_ms += randi_range(0, random_deviation_ms)

#------------------------------------------
# Fonctions privées
#------------------------------------------


