@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btinverter.png")
class_name BTInverter
extends BTDecorator


## The inverter node is a [i]decorator[/i] node returns [i]success[/i] when its child fails its execution,
## and [i]failure[/i] when its child succeeds its execution. When its child is [i]running[/i], it returns
## [i]running[/i] too.


#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

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
    var child_result:int = _children[0]._execute(actor, blackboard)
    if child_result == BTTickResult.SUCCESS:
        return BTTickResult.FAILURE
    if child_result == BTTickResult.FAILURE:
        return BTTickResult.SUCCESS
    return BTTickResult.RUNNING

#------------------------------------------
# Fonctions privées
#------------------------------------------
