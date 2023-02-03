@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btsuccess.png")
class_name BTSuccess
extends BTDecorator


## The success node is a [i]decorator[/i] node that always returns [i]success[/i] on child execution.


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
    return BTTickResult.SUCCESS

#------------------------------------------
# Fonctions privées
#------------------------------------------
