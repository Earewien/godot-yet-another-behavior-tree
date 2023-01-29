extends Node2D

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

var _shared_blackboard:BTBlackboard

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _ready() -> void:
    _shared_blackboard = BTBlackboard.new()
    _shared_blackboard.set_data("next_talking", "Alice")
    _shared_blackboard.set_data("players", [])

    $"PlayerAlice/BTRoot/".blackboard = _shared_blackboard
    $"PlayerBob/BTRoot/".blackboard = _shared_blackboard
    $"PlayerCharles/BTRoot/".blackboard = _shared_blackboard
    $"PlayerEmily/BTRoot/".blackboard = _shared_blackboard

#------------------------------------------
# Fonctions publiques
#------------------------------------------

#------------------------------------------
# Fonctions privées
#------------------------------------------

