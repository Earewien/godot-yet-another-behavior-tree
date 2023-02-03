@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btrandom.png")
class_name BTRandom
extends BTDecorator


## The random node is a [i]decorator[/i] node randomly execute its child. If the child is executed,
## the node result is the same as its child result. Otherwise, result is [i]failure[/i].


#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

## A float between [code]0[/code] (included) and [code]1[/code] (included) indicating the probability of child
## execution.
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

func tick(actor:Node, blackboard:BTBlackboard) -> int:
    var random_float:float = randf()
    if random_float > probability:
        return BTTickResult.FAILURE
    return _children[0]._execute(actor, blackboard)

#------------------------------------------
# Fonctions privées
#------------------------------------------
