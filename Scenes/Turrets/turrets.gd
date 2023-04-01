extends Node2D

@onready var turret = $Turret as Node2D

func _physics_process(delta):
	turn()
	
func turn():
	var enemy_position = get_global_mouse_position()
	turret.look_at(enemy_position)
