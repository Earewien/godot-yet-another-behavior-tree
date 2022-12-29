@tool
extends BTDecorator
class_name BTFailure
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btfailure.png")

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
    _children[0]._execute(actor, blackboard)
    return BTTickResult.FAILURE

#------------------------------------------
# Fonctions privées
#------------------------------------------
