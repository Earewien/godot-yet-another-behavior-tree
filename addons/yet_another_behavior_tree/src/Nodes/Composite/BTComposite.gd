@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btcomposite.png")
class_name BTComposite
extends BTNode


## Base object for all behavior tree composites.
## Composite nodes defines the root of a tree branch : each branch can be seen as a rule for your AI.
## They accept any kind of behavior tree nodes as children. It can either be a composite, decorator or leaf nodes
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
    if not _has_at_least_one_child():
        warnings.append("A composite must have at least one child node")
    if not _all_children_are_bt_nodes():
        warnings.append("A composite must have children nodes of type BTNode")
    return warnings

#------------------------------------------
# Fonctions publiques
#------------------------------------------

#------------------------------------------
# Fonctions privées
#------------------------------------------

func is_valid() -> bool:
    return _has_at_least_one_child() and _all_children_are_bt_nodes()

func _has_at_least_one_child() -> bool:
    return get_child_count() >= 1

func _all_children_are_bt_nodes() -> bool:
    for child in get_children():
        if not child is BTNode:
            return false
    return true
