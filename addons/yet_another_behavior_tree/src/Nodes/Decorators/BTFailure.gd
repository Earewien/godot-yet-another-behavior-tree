@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btfailure.png")
class_name BTFailure
extends BTDecorator


## The failure node is a [i]decorator[/i] node that always returns [i]failed[/i] on child execution.


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
    _children[0]._execute(actor, blackboard)
    return BTTickResult.FAILURE

#------------------------------------------
# Fonctions privées
#------------------------------------------
