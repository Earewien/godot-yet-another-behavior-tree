@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btnode.png")
extends Node
class_name BTNode

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

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _init() -> void:
    super._init()
    if _is_in_editor:
        _connect_signal_if_needed(child_entered_tree, _update_configuration_warnings_1)
        _connect_signal_if_needed(child_exiting_tree, _update_configuration_warnings_1)
        _connect_signal_if_needed(tree_entered, _update_configuration_warnings_0)
        _connect_signal_if_needed(tree_exited, _update_configuration_warnings_0)
    _connect_signal_if_needed(child_entered_tree, _update_cached_children)
    _connect_signal_if_needed(child_exiting_tree, _update_cached_children)

func _ready() -> void:
    if _is_in_editor:
        update_configuration_warnings()

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func tick(actor:Node2D, blackboard:BTBlackboard) -> int:
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

#------------------------------------------
# Fonctions privées
#------------------------------------------

func _update_configuration_warnings_0() -> void:
    update_configuration_warnings()

func _update_configuration_warnings_1(any) -> void:
    update_configuration_warnings()

func is_valid() -> bool:
    return false

func _update_cached_children(any) -> void:
    _children.clear()
    for child in get_children():
        if child is BTNode:
            _children.append(child)

func _execute(actor:Node2D, blackboard:BTBlackboard) -> int:
    if _is_in_editor:
        return BTTickResult.FAILURE

    _enter(blackboard);

    _start(actor, blackboard)

    var result:int = tick(actor, blackboard)
    if result != BTTickResult.RUNNING:
        _stop(actor, blackboard)

    _exit(blackboard)
    return result

func _enter(blackboard:BTBlackboard) -> void:
    enter(blackboard)
    pass

func _start(actor:Node2D, blackboard:BTBlackboard) -> void:
    var blackboard_namespace:String = str(actor.get_instance_id())
    blackboard.get_data("running_nodes", [], blackboard_namespace).append(self)

    if not blackboard.get_data("previously_running_nodes", [], blackboard_namespace).has(self):
        start(blackboard)

func _stop(actor:Node2D, blackboard:BTBlackboard) -> void:
    var blackboard_namespace:String = str(actor.get_instance_id())
    blackboard.get_data("running_nodes", [], blackboard_namespace).erase(self)
    exit(blackboard)
    stop(blackboard)

func _exit(blackboard:BTBlackboard) -> void:
    pass

func _connect_signal_if_needed(sig:Signal, callable:Callable) -> void:
    if not sig.is_connected(callable):
        sig.connect(callable)
