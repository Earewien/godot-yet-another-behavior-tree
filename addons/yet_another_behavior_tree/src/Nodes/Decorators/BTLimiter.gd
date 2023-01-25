@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btlimiter.png")
extends BTDecorator
class_name BTLimiter

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export_range(0, 9999999, 1) var limit:int = 1

@export var include_limit:bool = true

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

var _invocation_count:int = 0

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func tick(actor:Node, blackboard:BTBlackboard) -> int:
    var limit_reached:bool = _invocation_count >= limit
    if not include_limit:
        limit_reached = _invocation_count >= limit - 1

    if limit_reached:
        return BTTickResult.FAILURE

    var result:int = _children[0]._execute(actor, blackboard)
    if result != BTTickResult.RUNNING:
        _invocation_count += 1
    return result

#------------------------------------------
# Fonctions privées
#------------------------------------------
