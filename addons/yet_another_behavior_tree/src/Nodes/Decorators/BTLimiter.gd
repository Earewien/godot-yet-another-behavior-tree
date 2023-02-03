@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btlimiter.png")
class_name BTLimiter
extends BTDecorator


## The limiter node is a [i]decorator[/i] node that limits the total number of execution of its child node.
## When the limit is not reachs, the limiter nodes reports its child execution status. Once the limit is reachs,
## it never executs its child and always report a [i]failed[/i] execution.


#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

## Number of allowed child execution.
@export_range(0, 9999999, 1) var limit:int = 1

## Whether or not the [code]limit[/code] value is included into the number of times the child can run.
## It clarifies the usage of the limit.
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
