@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btparallel.png")
class_name BTParallel
extends BTComposite


## The parallel node is a [i]composite node[/i] that executes all its children at each [code]tick[/code].
## If at least one child is is running, the parallel reports it's running too. If no child is running,
## then if at least one child succeeded, the parallel reports success, else it reports failure.


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

func tick(actor:Node, blackboard:BTBlackboard) -> int:
    var at_least_one_child_running:bool = false
    var at_least_one_child_success:bool = false

    for child in _children:
        if child.process_mode != PROCESS_MODE_DISABLED:
            var result:int = child._execute(actor, blackboard)
            if result == BTTickResult.SUCCESS:
                at_least_one_child_success = true
            if result == BTTickResult.RUNNING:
                at_least_one_child_running = true

    # At least one running : this is still running !
    if at_least_one_child_running:
        return BTTickResult.RUNNING
    # No one is running, so, at least one success > success, else failure
    elif at_least_one_child_success:
        return BTTickResult.SUCCESS
    else:
        return BTTickResult.FAILURE

#------------------------------------------
# Fonctions publiques
#------------------------------------------

#------------------------------------------
# Fonctions privées
#------------------------------------------
