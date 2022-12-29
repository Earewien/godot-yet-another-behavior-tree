@tool
extends BTSelector
class_name BTRandomSelector
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btrandomselector.png")

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
    _children.shuffle()
