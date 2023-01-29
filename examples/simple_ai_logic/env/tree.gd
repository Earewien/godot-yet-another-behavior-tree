extends Node2D

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

@export var max_log_count:int = 3

#------------------------------------------
# Variables publiques
#------------------------------------------

#------------------------------------------
# Variables privées
#------------------------------------------

@onready var remaining_logs:int = max_log_count

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

func _draw():
    var poly = $ShapeFull/Leaves.polygon
    for i in range(1 , poly.size()):
        draw_line(poly[i-1] , poly[i], Color.BLACK , 1)
    draw_line(poly[poly.size() - 1] , poly[0], Color.BLACK , 1)

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func has_logs() -> bool:
    return remaining_logs > 0

func cut_log() -> void:
    if remaining_logs > 0:
        remaining_logs -= 1
    if remaining_logs == 0:
        queue_free()

#------------------------------------------
# Fonctions privées
#------------------------------------------

