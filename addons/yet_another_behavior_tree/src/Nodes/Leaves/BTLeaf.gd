@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btleaf.png")
class_name BTLeaf
extends BTNode


## Base object for all behavior tree leaves.
## Leaf nodes, as their name implies, do not have any child. They represents basic unit of work of your
## AI, which can be separated into two notions: conditions and actions.
## [b][u]This node should never be used directly.[/u][/b]


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

func _get_configuration_warnings() -> PackedStringArray:
    var warnings:PackedStringArray = []
    if not _has_no_child():
        warnings.append("A leaf must not have child")
    return warnings

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func is_leaf() -> bool:
    return true

#------------------------------------------
# Fonctions privées
#------------------------------------------

func is_valid() -> bool:
    return _has_no_child()

func _has_no_child() -> bool:
    return get_child_count() == 0

