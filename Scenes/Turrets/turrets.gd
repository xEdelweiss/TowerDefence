extends Node2D

const TURRET_TYPE_KEY = "turret_type"

@onready var turret = $Turret as Node2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer

var range_scene = preload("res://Scenes/range.tscn")
var enemy_array = []
var target_enemy = null
var built = false
var ready_to_fire = true

func _ready():
	setup_range()

func setup_range():
	var game_data = _get_game_data()
	if game_data == null:
		return
		
	var range_node = range_scene.instantiate() as Area2D
	range_node.body_entered.connect(_on_range_body_entered)
	range_node.body_exited.connect(_on_range_body_exited)
	range_node.get_node("CollisionShape2D").shape.radius = game_data.range / 2
	add_child(range_node)

func _physics_process(delta):
	select_enemy()
	turn()
	if target_enemy and ready_to_fire:
		fire()

func _get_game_data():
	if not has_meta(TURRET_TYPE_KEY):
		return null

	var turret_type = get_meta(TURRET_TYPE_KEY)

	if not GameData.tower_data.has(turret_type) or not GameData.tower_data[turret_type].range:
		return null

	return GameData.tower_data[turret_type]
	

func fire():
	var game_data = _get_game_data()
	if game_data == null:
		return
		
	ready_to_fire = false
	
	if game_data.category == "bullet":
		_fire_bullet()
	elif game_data.category == "missile":
		_fire_missile()
	
	target_enemy.on_hit(game_data.damage)
	await get_tree().create_timer(game_data.rate_of_fire).timeout
	ready_to_fire = true
	
func _fire_bullet():
	animation_player.play("fire")
	
func _fire_missile():
	pass

func select_enemy():
	if enemy_array.size() == 0 or built == false:
		target_enemy = null
		return

	target_enemy = _get_enemy_by_progress()

func _get_enemy_by_progress():
	var furthest = null
	for enemy in enemy_array:
		if furthest == null:
			furthest = enemy
		else:
			if (enemy as PathFollow2D).progress > (furthest as PathFollow2D).progress:
				furthest = enemy
	return furthest

func _get_closest_enemy():
	var closest = null
	for enemy in enemy_array:
		if closest == null:
			closest = enemy
		else:
			if position.distance_to(enemy.position) < position.distance_to(closest.position):
				closest = enemy
	return closest

func turn():
	if target_enemy:
		# var enemy_position = get_global_mouse_position()
		var enemy_position = target_enemy.position
		turret.look_at(enemy_position)

func _on_range_body_entered(body: Node2D):
	enemy_array.append(body.get_parent())
	print(enemy_array)

func _on_range_body_exited(body: Node2D):
	enemy_array.erase(body.get_parent())
	print(enemy_array)
