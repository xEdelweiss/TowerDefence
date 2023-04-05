extends CanvasLayer

class_name GameSceneUI

const TOWER_PREVIEW_CONTAINER = "TowerPreview"
const DRAG_TOWER = "DragTower"
const RANGE_SPRITE = "RangeSprite"

func set_tower_preview(tower_type: String, mouse_position: Vector2):
	var drag_tower = (load("res://Scenes/Turrets/" + tower_type.to_snake_case() + ".tscn") as PackedScene).instantiate() as Node2D
	drag_tower.name = DRAG_TOWER

	var range_texture = Sprite2D.new()
	var scaling = GameData.tower_data[tower_type].range / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	range_texture.texture = load("res://Assets/UI/range_overlay.png")
	range_texture.name = RANGE_SPRITE
	
	var container = Control.new()
	
	container.add_child(drag_tower, true)
	container.add_child(range_texture, true)

	container.position = mouse_position
	container.name = TOWER_PREVIEW_CONTAINER
	add_child(container, true)
	move_child(get_node(TOWER_PREVIEW_CONTAINER), 0)

func update_tower_preview(new_position: Vector2, color: String):
	var control = get_node(TOWER_PREVIEW_CONTAINER) as Control
	control.position = new_position

	var drag_tower = control.get_node(DRAG_TOWER) as Node2D
	var range_texture = control.get_node(RANGE_SPRITE) as Sprite2D
	if (drag_tower.modulate != Color(color)):
		drag_tower.modulate = Color(color)
		range_texture.modulate = Color(color)

func remove_tower_preview():
	get_node(TOWER_PREVIEW_CONTAINER).free()
