extends CanvasLayer

class_name GameSceneUI

@onready var hp = $InfoBar/HBoxContainer/HP as TextureProgressBar

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

func update_health_bar(health):
	var tween = create_tween()
	tween.tween_property(hp, "value", health, 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

	if health >= 60:
		hp.tint_progress = Color("499b00") # green
	elif health <= 60 and health >= 25:
		hp.tint_progress = Color("e1be32") # orange
	else:
		hp.tint_progress = Color("e11e1e") # red

##
## Game Controls
##

func _on_pause_play_button_pressed():
	var scene_tree = get_tree() as SceneTree
	var game_scene = (get_parent() as GameScene)
	
	if game_scene.build_mode:
		game_scene.cancel_build_mode()

	if scene_tree.paused:
		scene_tree.paused = false
	elif game_scene.current_wave == 0:
		game_scene.current_wave += 1
		get_node("MarginContainer/HUD/VBoxContainer/IntroLabel").hide()
		game_scene.start_next_wave()
		scene_tree.paused = false
	else:
		scene_tree.paused = true


func _on_speed_up_button_pressed():
	var game_scene = (get_parent() as GameScene)

	if game_scene.build_mode:
		game_scene.cancel_build_mode()

	if Engine.time_scale == 1:
		Engine.time_scale = 2
	else:
		Engine.time_scale = 1
