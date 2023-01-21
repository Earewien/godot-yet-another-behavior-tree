@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btrandomselector.png")
extends BTSelector
class_name BTRandomSelector

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

#------------------------------------------
# Fonctions privées
#------------------------------------------

func start(blackboard:BTBlackboard) -> void:
    super.start(blackboard)
    if not save_progression or _running_child_index == -1:
        _children.shuffle()
