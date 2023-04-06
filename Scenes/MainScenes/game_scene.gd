extends Node2D

class_name GameScene

const OBSTRUCTED_TILE_ID = 5

@onready var ui = $UI as GameSceneUI

var map_node: Node2D

var build_mode = false
var build_valid = false
var build_location: Vector2
var build_tile: Vector2i
var build_type: String

var current_wave = 0
var enemies_in_wave = 0

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

##
## Building Functions
##

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
		new_tower.built = true
		new_tower.position = build_location
		new_tower.set_meta("turret_type", new_tower.name)
		map_node.get_node("Turrets").add_child(new_tower, true)

		var tower_exclusion = map_node.get_node("TowerExclusion") as TileMap
		tower_exclusion.set_cell(0, build_tile, OBSTRUCTED_TILE_ID, Vector2i(1, 0))
		# todo: deduct cash
		# todo: update cash label

##
## Wave Functions
##

func start_next_wave():
	var wave_data = retrieve_wave_data()
	await get_tree().create_timer(0.2).timeout
	# yield(get_tree().create_timer(0.2), "timeout")
	spawn_enemies(wave_data)

func retrieve_wave_data():
	var wave_data = [["BlueTank", 1.5], ["BlueTank", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data:
		print("res://Scenes/Enemies/" + i[0].to_snake_case() + ".tscn")
		var new_enemy = (load("res://Scenes/Enemies/" + i[0].to_snake_case() + ".tscn") as PackedScene).instantiate() as PathFollow2D
		get_random_enemy_path().add_child(new_enemy, true)
		await get_tree().create_timer(i[1]).timeout
		#yield(get_tree().create_timer(i[1]), "timeout")

func get_random_enemy_path() -> Path2D:
	return map_node.get_node(str("EnemyPath", randi_range(1, 2)))
