@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btactionwait.png")
class_name BTActionWait
extends BTLeaf


## The wait action node is a [i]leaf[/i] node. Its execution returns [i]running[/i] during the specified wait time,
## then returns *success* when specified time is elapsed. After succeeded, the wait time is rearmed for next
## tree execution.


#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

## Number of milliseconds to wait before returning [i]success[/i]
@export var wait_time_ms:int = 1_000

## Indicates if a random deviation should be applied to the wait time. [code]0[/code] means there is no
## deviation et the wait time will be strictyl respected. Random deviation may change after each node rearm.
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


