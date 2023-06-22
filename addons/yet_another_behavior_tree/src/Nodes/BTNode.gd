@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btnode.png")
class_name BTNode
extends Node


## Base object for all behavior tree nodes.
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

@onready var _is_in_editor:bool = Engine.is_editor_hint()
var _children:Array[BTNode] = []
var _tree_root:BTRoot

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _init() -> void:
    if _is_in_editor:
        _connect_signal_if_needed(child_entered_tree, _update_configuration_warnings_1)
        _connect_signal_if_needed(child_exiting_tree, _update_configuration_warnings_1)
        _connect_signal_if_needed(tree_entered, _update_configuration_warnings_0)
        _connect_signal_if_needed(tree_exited, _update_configuration_warnings_0)
    _connect_signal_if_needed(tree_entered, _update_cached_tree_root)
    _connect_signal_if_needed(tree_exited, _update_cached_tree_root)
    _connect_signal_if_needed(child_entered_tree, _update_cached_children)
    _connect_signal_if_needed(child_exiting_tree, _update_cached_children)

func _ready() -> void:
    if _is_in_editor:
        update_configuration_warnings()

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func tick(actor:Node, blackboard:BTBlackboard) -> int:
    return BTTickResult.SUCCESS

func is_leaf() -> bool:
    return false

func enter(blackboard:BTBlackboard) -> void:
    pass

func start(blackboard:BTBlackboard) -> void:
    pass

func stop(blackboard:BTBlackboard) -> void:
    pass

func exit(blackboard:BTBlackboard) -> void:
    pass

## Reset node state, as it is was just instantiated
func reset() -> void:
    pass

#------------------------------------------
# Fonctions privées
#------------------------------------------

func _update_configuration_warnings_0() -> void:
    update_configuration_warnings()

func _update_configuration_warnings_1(any) -> void:
    update_configuration_warnings()

func is_valid() -> bool:
    return false

func _update_cached_tree_root() -> void:
    _tree_root = null
    var parent:Node = get_parent()
    while is_instance_valid(parent):
        if parent is BTRoot:
            _tree_root = parent
            break
        parent = parent.get_parent()

func _update_cached_children(any) -> void:
    _children.clear()
    for child in get_children():
        if child is BTNode:
            _children.append(child)

func _execute(actor:Node, blackboard:BTBlackboard) -> int:
    if _is_in_editor:
        return BTTickResult.FAILURE

    var local_state:Dictionary = _tree_root._internal_state.get(actor.get_instance_id())

    enter(blackboard)

    _start(actor, blackboard, local_state)

    var result:int = tick(actor, blackboard)
    if result != BTTickResult.RUNNING:
        _stop(actor, blackboard, local_state)

    return result

func _start(actor:Node, blackboard:BTBlackboard, local_state:Dictionary) -> void:
    local_state["running_nodes"].append(self)

    if not local_state["previously_running_nodes"].has(self):
        start(blackboard)

func _stop(actor:Node, blackboard:BTBlackboard, local_state:Dictionary) -> void:
    local_state["running_nodes"].erase(self)
    exit(blackboard)
    stop(blackboard)

func _connect_signal_if_needed(sig:Signal, callable:Callable) -> void:
    if not sig.is_connected(callable):
        sig.connect(callable)
