@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btparallel.png")
extends BTComposite
class_name BTParallel

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

func tick(actor:Node2D, blackboard:BTBlackboard) -> int:
    var at_least_one_child_running:bool = false
    var at_least_one_child_success:bool = false

    for child in _children:
        var result:int = child._execute(actor, blackboard)
        if result == BTTickResult.SUCCESS:
            at_least_one_child_success = true
        if result == BTTickResult.RUNNING:
            at_least_one_child_running = true

    # At least one runn ing : this is still running !
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
