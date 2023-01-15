extends Node
class_name BTBlackboard
@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btblackboard.png")

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Variables publiques
#------------------------------------------

@export var data:Dictionary = {}

#------------------------------------------
# Variables privées
#------------------------------------------

var _execution_data:Dictionary = {}

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _ready() -> void:
    # On copie le dico défini par l'utilisateur dans le dico privé
    _execution_data.merge(data)

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func get_delta() -> float:
    return get_data("delta")

func has_data(key:Variant) -> bool:
    return get_data(key) != null

func get_data(key:Variant, default_value:Variant = null) -> Variant:
    var result:Variant = _execution_data.get(key, default_value)
    return result.get_ref() if result is WeakRef else result

func set_data(key:Variant, value:Variant) -> Variant:
    var old_value:Variant = _execution_data[key] if _execution_data.has(key) else null
    _execution_data[key] = weakref(value) if value is Node else value
    return old_value.get_ref() if old_value is WeakRef else old_value

func delete_data(key:Variant) -> Variant:
    var old_value = _execution_data[key] if _execution_data.has(key) else null
    _execution_data.erase(key)
    return old_value.get_ref() if old_value is WeakRef else old_value

#------------------------------------------
# Fonctions privées
#------------------------------------------
