@tool
extends BTComposite
class_name BTSequence
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btsequence.png")


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

func tick(actor:Node2D, blackboard:BTBlackboard) -> int:
    for child in _children:
        var result:int = child._execute(actor, blackboard)
        if result != BTTickResult.SUCCESS:
            return result

    return BTTickResult.SUCCESS

#------------------------------------------
# Fonctions publiques
#------------------------------------------

#------------------------------------------
# Fonctions privées
#------------------------------------------
