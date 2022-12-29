@tool
extends Node
class_name BTNode
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btnode.png")

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
        child_entered_tree.connect(_update_configuration_warnings_1)
        child_exiting_tree.connect(_update_configuration_warnings_1)
        tree_entered.connect(_update_configuration_warnings_0)
        tree_exited.connect(_update_configuration_warnings_0)
    child_entered_tree.connect(_update_cached_children)
    child_exiting_tree.connect(_update_cached_children)

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
    _children = get_children().map(_node_as_bt_node)

func _execute(actor:Node2D, blackboard:BTBlackboard) -> int:
    if _is_in_editor:
        return BTTickResult.FAILURE

    _enter(blackboard);

    _start(blackboard)

    var result:int = tick(actor, blackboard)
    if result != BTTickResult.RUNNING:
        _stop(blackboard)

    _exit(blackboard)
    return result

func _node_as_bt_node(node:Node) -> BTNode:
    return node as BTNode

func _enter(blackboard:BTBlackboard) -> void:
    enter(blackboard)
    pass

func _start(blackboard:BTBlackboard) -> void:
    blackboard.get_data("running_nodes", []).append(self)

    if not blackboard.get_data("previously_running_nodes", []).has(self):
        start(blackboard)

func _stop(blackboard:BTBlackboard) -> void:
    blackboard.get_data("running_nodes", []).erase(self)
    stop(blackboard)

func _exit(blackboard:BTBlackboard) -> void:
    exit(blackboard)
    pass

