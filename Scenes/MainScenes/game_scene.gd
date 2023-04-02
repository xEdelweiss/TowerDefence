extends Node2D

const OBSTRUCTED_TILE_ID = 5

@onready var ui = $UI as GameSceneUI

var map_node: Node2D

var build_mode = false
var build_valid = false
var build_location: Vector2
var build_tile: Vector2i
var build_type: String

func _ready():
	map_node = get_node("Map1") # todo: remove hardcode
	
	for i in get_tree().get_nodes_in_group("build_buttons") as Array[Button]:
		i.pressed.connect(initiate_build_mode.bind(i.name))
	
func _process(delta):
	if build_mode:
		update_tower_preview()
	
func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode:
		cancel_build_mode()
	
	if event.is_action_released("ui_accept") and build_mode:
		verify_and_build()
		cancel_build_mode()
	
func initiate_build_mode(tower_type: String):
	if build_mode:
		cancel_build_mode()
	
	build_type = tower_type + "T1"
	build_mode = true
	ui.set_tower_preview(build_type, get_global_mouse_position())
	
func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var tower_exclusion = map_node.get_node("TowerExclusion") as TileMap
	
	var current_tile_position = tower_exclusion.local_to_map(mouse_position)
	var tile_position = tower_exclusion.map_to_local(current_tile_position)

	if tower_exclusion.get_cell_source_id(0, current_tile_position) == -1:
		ui.update_tower_preview(tile_position, "adff4577")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile_position
	else:
		ui.update_tower_preview(tile_position, "ff333377")
		build_valid = false
	
func cancel_build_mode():
	ui.remove_tower_preview()
	build_mode = false
	build_valid = false
	
func verify_and_build():
	if build_valid:
		# todo: check if user has enough cash
		var new_tower = (load("res://Scenes/Turrets/" + build_type.to_snake_case() + ".tscn") as PackedScene).instantiate() as Node2D
		new_tower.position = build_location
		map_node.get_node("Turrets").add_child(new_tower, true)

		var tower_exclusion = map_node.get_node("TowerExclusion") as TileMap
		tower_exclusion.set_cell(0, build_tile, OBSTRUCTED_TILE_ID, Vector2i(1, 0))
		# todo: deduct cash
		# todo: update cash label
