extends Node2D

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export var player_name:String = "":
    set(value):
        player_name = value
        if _name_label:
            _name_label.text = player_name

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

@onready var _text_label:Label = $GUI/Text
@onready var _name_label:Label = $GUI/Name

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _ready() -> void:
    _name_label.text = player_name

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func declare_presence(blackboard:BTBlackboard) -> int:
    blackboard.get_data("players").append(player_name)
    return BTTickResult.SUCCESS

func is_my_turn_to_talk(next_talking:String) -> bool:
    return player_name == next_talking

func talk() -> int:
    _text_label.visible = true
    get_tree().create_timer(1).timeout.connect(func():_text_label.visible = false)
    return BTTickResult.SUCCESS

func choose_next_player_talking(blackboard:BTBlackboard) -> int:
    blackboard.set_data("next_talking", _pick_next_player(blackboard.get_data("players")))
    return BTTickResult.SUCCESS

#------------------------------------------
# Fonctions privées
#------------------------------------------

func _pick_next_player(players:Array) -> String:
    var result:String = players.pick_random()
    while result == player_name:
        result = players.pick_random()
    return result
