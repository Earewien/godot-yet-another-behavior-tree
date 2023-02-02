@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btrandomselector.png")
class_name BTRandomSelector
extends BTSelector


## The random selector node is a [i]composite node[/i] that behaves like the [code]BTSelector[/code] node,
## except that it executes its children in random order.


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
