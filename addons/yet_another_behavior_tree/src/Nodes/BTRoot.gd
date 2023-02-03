@tool
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btroot.png")
class_name BTRoot
extends BTNode


## This behavior tree is a Godot node that can be added to your Scene tree. The logic inside tree nodes
## will be run every frame, during process or physics process, depending on tree process mode.
## [br][br]
## At each frame, the [code]tick[/code] function of tree nodes will be run. This function has access to the
## [i]actor[/i] (the node the tree is describing behavior for), and a [i]blackboard[/i] (allowing to share
## data between nodes). The tick function can either returns:
## [br]
## - [code]SUCCESS[/code], indicating that node execution is successful,[br]
## - [code]RUNNING[/code], indicating that node is doing a long computation/action/whatever you want, that is not finished yet,[br]
## - [code]FAILURE[/code], indicating that something went wrong during child execution (condition not met, ...).
## [br][br]
## Depending on your tree structure, node result will produce various behaviors. See node documentation for
## mor details.


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

## Indicates if tree should run or not
@export var enabled:bool = true:
    set(value):
        enabled = value
        set_process(enabled)
        set_physics_process(enabled)

## Indicates whether tree should execute during [i]process[/i] or [i]physics process[/i].
@export var root_process_mode:BTRootProcessMode = BTRootProcessMode.PHYSIC_PROCESS

## Path to the node that the tree is drescribing actions for. This is the node that will be passed to all
## tree nodes, allowing you to manipulate the actor at every tree step.
@export var actor_path:NodePath :
    set(value):
        actor_path = value
        _update_actor_from_path()
        update_configuration_warnings()

## Path to the blackboard node. This allows to share a same blackboard between several trees, for example to code
## a group of enemies acting together, or to specify some default entries using the editor. If empty, a default
## empty blackboard will be used during tree execution.
@export var blackboard:BTBlackboard = null :
    set(value):
        blackboard = value
        _update_blackboard()
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

var _execution_start_time_ms:float
var _execution_stop_time_ms:float

@onready var _performance_monitor_identifier:String = "BTRoot/%s-%s" % [get_name(), get_instance_id()]

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _ready() -> void:
    super._ready()

    if not is_valid():
        push_error("BTRoot '%s'(%s) is not valid, check its configuration" % [get_name(), get_instance_id()])
    # Init du blackboard:  soit celui de l'utilisateur, soit un tout neuf
    _update_blackboard()

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

func _update_blackboard() -> void:
    if blackboard != null and is_instance_valid(blackboard):
        _blackboard= blackboard
    else:
        _blackboard = BTBlackboard.new()

func _update_actor_from_path() -> void:
    _actor = get_node_or_null(actor_path)
    if not is_instance_valid(_actor) and is_inside_tree():
        # Fallback : si le chemin donné n'était pas relatif à la scene courante, on le check en absolu
        _actor = get_tree().current_scene.get_node_or_null(actor_path)

func _do_execute(delta:float):
    _register_execution_start()
    var blackboard_namespace:String = str(_actor.get_instance_id())
    # delta est une donnée volatile, elle n'est donc pas dans un namespace puisque chaque arbre tourne
    # séquentiellement, donc il n'y a pas de collision de données en cas de partage du blackboard
    _blackboard.set_data("delta", delta)
    _blackboard.set_data("previously_running_nodes", Array(_previous_running_nodes), blackboard_namespace)
    _blackboard.set_data("running_nodes", [], blackboard_namespace)

    _children[0]._execute(_actor, _blackboard)

    var raw_running_nodes:Array = _blackboard.get_data("running_nodes", [], blackboard_namespace)
    var running_nodes:Array[BTNode] = []
    running_nodes.append_array(raw_running_nodes)
    if _previous_running_nodes != running_nodes:
        for n in _previous_running_nodes:
            if not running_nodes.has(n):
                n._stop(_actor, _blackboard)

        if not running_nodes.is_empty():
            var running_node_names:Array[String] = []
            for running_node in running_nodes:
                if running_node.is_leaf():
                    running_node_names.append(str(running_node.name))
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
