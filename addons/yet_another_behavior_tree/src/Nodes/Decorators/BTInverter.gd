@tool
extends BTDecorator
class_name BTInverter
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btinverter.png")

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

func tick(actor:Node2D, blackboard:BTBlackboard) -> int:
    var child_result:int = _children[0]._execute(actor, blackboard)
    if child_result == BTTickResult.SUCCESS:
        return BTTickResult.FAILURE
    if child_result == BTTickResult.FAILURE:
        return BTTickResult.SUCCESS
    return BTTickResult.RUNNING

#------------------------------------------
# Fonctions privées
#------------------------------------------
