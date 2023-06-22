@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btsequence.png")
class_name BTSequence
extends BTComposite


## The sequence node is a [i]composite node[/i] that executes its children from the first one to the last
## one, until all children succeed or one of its children fails. If all children succeed, the sequence
## succeeds too ; if one child fails, the sequence fails too.


#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

## Indicates whether the sequence should resume to the last running child on next tree execution ([code]on[/code]),
## or restart from its first child ([code]off[/code]). Its usefull to describe a non-interruptible action, or to
## optimize process time.
@export var save_progression:bool = false

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

var _running_child_index:int = -1

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func tick(actor:Node, blackboard:BTBlackboard) -> int:
    for child_index in _children.size():
        if not save_progression or child_index >= _running_child_index:
            var child:BTNode = _children[child_index]
            if child.process_mode != PROCESS_MODE_DISABLED:
                var result:int = child._execute(actor, blackboard)
                if result != BTTickResult.SUCCESS:
                    if save_progression and result == BTTickResult.RUNNING:
                        _running_child_index = child_index
                    return result

    return BTTickResult.SUCCESS

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func reset() -> void:
    _running_child_index = -1
    super.reset()

#------------------------------------------
# Fonctions privées
#------------------------------------------

func start(blackboard:BTBlackboard) -> void:
    _running_child_index = 0

func stop(blackboard:BTBlackboard) -> void:
    _running_child_index = -1
