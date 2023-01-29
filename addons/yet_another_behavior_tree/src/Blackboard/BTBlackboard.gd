@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btblackboard.png")
extends Node
class_name BTBlackboard

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

## Will be added to default namespace !
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

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _ready() -> void:
    # On copie le dico défini par l'utilisateur dans le dico privé
    _get_namespace_board(DEFAULT_NAMESPACE).merge(data)

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func get_delta() -> float:
    # Delta is not in any namespace, since its a volatile data, that is valid just inside one tree tick
    return get_data("delta")

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

#------------------------------------------
# Fonctions privées
#------------------------------------------

func _get_namespace_board(board_namespace:String) -> Dictionary:
    if not _execution_data.has(board_namespace):
        _execution_data[board_namespace] = {}
    return _execution_data[board_namespace]
