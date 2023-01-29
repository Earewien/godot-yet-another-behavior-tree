extends Node2D

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export_category("Logger")

@export var max_log_capacity:int = 2

#------------------------------------------
# Variables publiques
#------------------------------------------

var logs_count:int = 0

#------------------------------------------
# Variables privées
#------------------------------------------

@onready var _btroot:BTRoot = $AI

var _cutting_log:bool = false
var _cutting_tree:Node2D

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func on_state_entered() :
    _btroot.on_running.connect(func(s):print(s))
    _btroot.on_idle.connect(func():print("idle..."))
    _btroot.enabled = true

func can_carry_more_logs() -> bool:
    return logs_count < max_log_capacity

func has_no_log() -> bool:
    return logs_count == 0

func has_remaining_trees() -> bool:
    return not get_tree().get_nodes_in_group("tree").is_empty()

func get_nearest_tree() -> Node2D:
    var nearest_tree:Node2D
    var nearest_distance_to_tree:float = 99999.0
    for tree in get_tree().get_nodes_in_group("tree"):
        var distance_to_tree:float = global_position.distance_to(tree.global_position)
        if distance_to_tree < nearest_distance_to_tree:
            nearest_distance_to_tree = distance_to_tree
            nearest_tree = tree
    return nearest_tree

func get_nearest_warehouse() -> Node2D:
    var nearest_warehouse:Node2D
    var nearest_distance_to_warehouse:float = 99999.0
    for warehouse in get_tree().get_nodes_in_group("warehouse"):
        var distance_to_warehouse:float = global_position.distance_to(warehouse.global_position)
        if distance_to_warehouse < nearest_distance_to_warehouse:
            nearest_distance_to_warehouse = distance_to_warehouse
            nearest_warehouse = warehouse
    return nearest_warehouse

func tree_is_valid(tree:Node2D) -> bool:
    return is_instance_valid(tree) and tree.has_logs()

func cut_log(tree:Node2D) -> int:
    if not _cutting_log:
        _cutting_log = true
        _cutting_tree = tree
        get_tree().create_timer(1).timeout.connect(_on_log_cut, CONNECT_ONE_SHOT)
    return BTTickResult.RUNNING if _cutting_log else BTTickResult.FAILURE

func drop_logs_to_warehouse() -> void:
    logs_count = 0

func move_to(delta:float, node:Node2D) -> int:
    if global_position.distance_to(node.global_position) > 10:
        global_position = global_position.move_toward(node.global_position, delta * 300)
        return BTTickResult.RUNNING
    else:
        return BTTickResult.SUCCESS


#------------------------------------------
# Fonctions privées
#------------------------------------------

func _on_log_cut() -> void:
    if is_instance_valid(_cutting_tree):
        _cutting_tree.cut_log()
        _cutting_tree = null
        logs_count += 1
    _cutting_log = false
