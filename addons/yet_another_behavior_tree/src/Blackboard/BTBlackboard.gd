@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btblackboard.png")
class_name BTBlackboard
extends Node


## Blackboard allows to share data across nodes and behavior trees. You can create/retrieve/erase
## pairs of key-value. Keys and values are variants and can be anything.
## [br][br]
## Data in blackboard can be isolated in so-called [i]namespaces[/i]. A data key can exists only once in
## a namespace, but can exists multiple times across namespaces, allowing the user to isolate data when,
## for example, a blackboard is shared between multiple behavior trees. By default, if no namespace is
## specified when inserting a data into a blackboard, the [i]default namespace[/i] is used.


const DEFAULT_NAMESPACE:String = "_default_namespace"

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Variables publiques
#------------------------------------------

## A dictionnary allowing to specifies default entries before tree first execution.
## [br][br]
## Those entries are added in the default namespace of the blackboard. If you want to add default entries
## in another namespace, you must do it in a script.
@export var data:Dictionary = {}

#------------------------------------------
# Variables privées
#------------------------------------------

# {
#    "namespace" : {
#       DATAS
#    }
# }
var _execution_data:Dictionary = {}
var _default_namespace_data:Dictionary

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _ready() -> void:
    # On copie le dico défini par l'utilisateur dans le dico privé
    _init_default_namespace()

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func get_delta() -> float:
    # Delta is not in any namespace, since its a volatile data, that is valid just inside one tree tick
    return _default_namespace_data["delta"]

func has_data(key:Variant, board_namespace:String = DEFAULT_NAMESPACE) -> bool:
    var namespace_dico:Dictionary = _get_namespace_board(board_namespace)
    return namespace_dico.has(key)

func get_data(key:Variant, default_value:Variant = null, board_namespace:String = DEFAULT_NAMESPACE) -> Variant:
    var result:Variant = _get_namespace_board(board_namespace).get(key, default_value)
    return result.get_ref() if result is WeakRef else result

func set_data(key:Variant, value:Variant, board_namespace:String = DEFAULT_NAMESPACE) -> Variant:
    var namespace_dico:Dictionary = _get_namespace_board(board_namespace)
    var old_value:Variant = namespace_dico[key] if namespace_dico.has(key) else null
    namespace_dico[key] = weakref(value) if value is Node else value
    return old_value.get_ref() if old_value is WeakRef else old_value

func delete_data(key:Variant, board_namespace:String = DEFAULT_NAMESPACE) -> Variant:
    var namespace_dico:Dictionary = _get_namespace_board(board_namespace)
    var old_value = namespace_dico[key] if namespace_dico.has(key) else null
    namespace_dico.erase(key)
    return old_value.get_ref() if old_value is WeakRef else old_value

## Reset the whole blackboard, erasing all data from it.
## Data set in node configuration through [data] field is restored
func reset() -> void:
    # To prevent tree from just stop working, we preserve delta value into the blackboard
    # It's an internal state, shoumd never be erased by user
    var delta:float = get_delta()
    _execution_data.clear()
    _init_default_namespace()
    _unsafe_set_delta(delta)

#------------------------------------------
# Fonctions privées
#------------------------------------------

func _init_default_namespace() -> void:
    _default_namespace_data = _get_namespace_board(DEFAULT_NAMESPACE)
    _default_namespace_data.merge(data)

func _get_namespace_board(board_namespace:String) -> Dictionary:
    if not _execution_data.has(board_namespace):
        _execution_data[board_namespace] = {}
    return _execution_data[board_namespace]

func _unsafe_set_delta(value:float) -> void:
    _default_namespace_data["delta"] = value
