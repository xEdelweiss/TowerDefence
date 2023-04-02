extends CanvasLayer

class_name GameSceneUI

const TOWER_PREVIEW = "TowerPreview"
const DRAG_TOWER = "DragTower"

func set_tower_preview(tower_type: String, mouse_position: Vector2):
	var drag_tower = (load("res://Scenes/Turrets/" + tower_type.to_snake_case() + ".tscn") as PackedScene).instantiate() as Node2D
	drag_tower.name = DRAG_TOWER
	drag_tower.modulate = Color("ab54ff3c")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.position = mouse_position
	control.name = TOWER_PREVIEW
	add_child(control, true)
	move_child(get_node(TOWER_PREVIEW), 0)

func update_tower_preview(new_position: Vector2, color: String):
	var control = get_node(TOWER_PREVIEW) as Control
	control.position = new_position
#
	var drag_tower = control.get_node(DRAG_TOWER) as Node2D
	if (drag_tower.modulate != Color(color)):
		drag_tower.modulate = Color(color)

func remove_tower_preview():
	get_node(TOWER_PREVIEW).queue_free()
