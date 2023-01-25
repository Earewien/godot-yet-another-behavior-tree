@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btsequence.png")
extends BTComposite
class_name BTSequence


#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export var save_progression:bool = false

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func tick(actor:Node, blackboard:BTBlackboard) -> int:
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
