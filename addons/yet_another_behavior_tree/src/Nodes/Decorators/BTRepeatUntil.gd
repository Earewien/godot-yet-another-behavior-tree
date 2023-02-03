@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btrepeatuntil.png")
class_name BTRepeatUntil
extends BTDecorator


## The repeat until node is a [i]decorator[/i] node that loop its child execution until child execution result
## is as excepted. It is possible to specifies the maximum number of loop execution allowed to obtain the desired
## result. If desired result is obtained before the loop execution limit, the repeat until node returns the
## obtained result. If not, its returns a [i]failure[/i].


#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

## Expected child result to stop the loop.
@export_enum("SUCCESS:0", "RUNNING:1", "FAILURE:2") var stop_condition:int = 0

## Maximum number of child execution to obtain the desired result. If value is [code]0[/code], there is
## [b]no limit[/b] to the number of times the loop can run (⚠️ be careful to not create an infinite loop).
## If value is more than zero, its represents the maximum number of loop execution.
@export_range(0, 999999) var max_iteration:int = 0

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func tick(actor:Node, blackboard:BTBlackboard) -> int:
    var result:int
    var not_stopped:bool = true
    var iteration_count:int = 0
    while not_stopped:
        result = _children[0]._execute(actor, blackboard)
        if stop_condition == BTTickResult.SUCCESS and result == BTTickResult.SUCCESS:
            not_stopped = false
        if stop_condition == BTTickResult.RUNNING and result == BTTickResult.RUNNING:
            not_stopped = false
        if stop_condition == BTTickResult.FAILURE and result == BTTickResult.FAILURE:
            not_stopped = false

        if max_iteration > 0:
            iteration_count += 1
            if not not_stopped and iteration_count > max_iteration:
                not_stopped = false

    return result

#------------------------------------------
# Fonctions privées
#------------------------------------------
