@tool
extends BTDecorator
class_name BTRandom
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btrandom.png")

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export_range(0, 1) var probability:float = 0.5

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
    var random_float:float = randf()
    if random_float > probability:
        return BTTickResult.FAILURE
    return _children[0]._execute(actor, blackboard)

#------------------------------------------
# Fonctions privées
#------------------------------------------
