extends Node2D

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

func _process(_delta:float) -> void:
    if Input.is_action_just_released("ui_accept"):
        var new_tree:Node2D = preload("res://examples/simple_ai_logic/env/tree.tscn").instantiate()
        new_tree.global_position = get_global_mouse_position()
        $Trees.add_child(new_tree)

#------------------------------------------
# Fonctions publiques
#------------------------------------------

#------------------------------------------
# Fonctions privées
#------------------------------------------

