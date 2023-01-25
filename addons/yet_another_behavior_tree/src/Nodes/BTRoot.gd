@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btroot.png")
extends BTNode
class_name BTRoot

enum BTRootProcessMode {
    PROCESS,
    PHYSIC_PROCESS
}

#------------------------------------------
# Signaux
#------------------------------------------

signal on_running(running_node_names:Array)
signal on_idle()

#------------------------------------------
# Exports
#------------------------------------------

@export var enabled:bool = true:
    set(value):
        enabled = value
        set_process(enabled)
        set_physics_process(enabled)

@export var root_process_mode:BTRootProcessMode = BTRootProcessMode.PHYSIC_PROCESS

@export var actor_path:NodePath :
    set(value):
        actor_path = value
        _update_actor_from_path()
        update_configuration_warnings()

@export var blackboard:BTBlackboard = null :
    set(value):
        blackboard = value
        update_configuration_warnings()

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

var _blackboard:BTBlackboard
var _previous_running_nodes:Array[BTNode] = []
var _actor:Node
var _execution_blackboard:BTBlackboard

var _execution_start_time_ms:float
var _execution_stop_time_ms:float

@onready var _performance_monitor_identifier:String = "BTRoot/%s-%s" % [get_name(), get_instance_id()]

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _ready() -> void:
    super._ready()

    if not is_valid():
        enabled = false
    # Init du blackboard:  soit celui de l'utilisateur, soit un tout neuf
    if blackboard != null and is_instance_valid(blackboard):
        _blackboard= blackboard
    else:
        _blackboard = BTBlackboard.new()

    if not Engine.is_editor_hint():
        _add_custom_performance_monitor()
        tree_entered.connect(_add_custom_performance_monitor)
        tree_exited.connect(_remove_custom_performance_monitor)

func _process(delta:float) -> void:
    if not Engine.is_editor_hint() and enabled and root_process_mode == BTRootProcessMode.PROCESS:
        _do_execute(delta)

func _physics_process(delta:float) -> void:
    if not Engine.is_editor_hint() and enabled and root_process_mode == BTRootProcessMode.PHYSIC_PROCESS:
        _do_execute(delta)

func _get_configuration_warnings() -> PackedStringArray:
    var warnings:PackedStringArray = []
    if not _check_direct_children_validity():
        warnings.append("Root tree must contains only one child of type BTComposite")
    if not _check_actor_validity():
        warnings.append("Root tree actor must be filled")
    return warnings

#------------------------------------------
# Fonctions publiques
#------------------------------------------

#------------------------------------------
# Fonctions privées
#------------------------------------------

func is_valid() -> bool:
    return _check_direct_children_validity() and _check_actor_validity()

func _check_direct_children_validity() -> bool:
    var is_valid:bool = get_child_count() == 1
    if is_valid:
        is_valid = get_child(0) is BTComposite
    return is_valid

func _check_actor_validity() -> bool:
    var is_valid:bool = actor_path != null and not actor_path.is_empty()
    if is_valid:
        _update_actor_from_path()
        is_valid =_actor != null and is_instance_valid(_actor)
    return is_valid

func _update_actor_from_path() -> void:
    _actor = get_node_or_null(actor_path)
    if not is_instance_valid(_actor) and is_inside_tree():
        # Fallback : si le chemin donné n'était pas relatif à la scene courante, on le check en absolu
        _actor = get_tree().current_scene.get_node_or_null(actor_path)

func _do_execute(delta:float):
    _register_execution_start()
    _blackboard.set_data("delta", delta)
    _blackboard.set_data("previously_running_nodes", Array(_previous_running_nodes))
    _blackboard.set_data("running_nodes", [])

    _children[0]._execute(_actor, _blackboard)

    var running_nodes:Array[BTNode] = _blackboard.get_data("running_nodes", [])
    if _previous_running_nodes != running_nodes:
        for n in _previous_running_nodes:
            if not running_nodes.has(n):
                n._stop( _blackboard)

        if not running_nodes.is_empty():
            var running_node_names:Array[String] = running_nodes.filter(func(n): return n.is_leaf()).map(func(n): return str(n.name))
            on_running.emit(running_node_names)
        else:
            on_idle.emit()
        _previous_running_nodes = running_nodes
    _register_execution_stop()

func _add_custom_performance_monitor() -> void:
    if not Performance.has_custom_monitor(_performance_monitor_identifier):
        Performance.add_custom_monitor(_performance_monitor_identifier, _compute_last_exec_time)

func _remove_custom_performance_monitor() -> void:
    if Performance.has_custom_monitor(_performance_monitor_identifier):
        Performance.remove_custom_monitor(_performance_monitor_identifier)

func _register_execution_start() -> void:
    _execution_start_time_ms = Time.get_ticks_msec()

func _register_execution_stop() -> void:
    _execution_stop_time_ms = Time.get_ticks_msec()

func _compute_last_exec_time() -> float:
    return _execution_stop_time_ms - _execution_start_time_ms
