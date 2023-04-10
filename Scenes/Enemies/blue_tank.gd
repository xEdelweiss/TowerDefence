extends PathFollow2D

class_name BlueTank	

signal on_base_damage(damage)

var speed = 150
var hp = 1000
var base_damage = 21

@onready var health_bar = $HealthBar
@onready var impact_area = $Impact
@onready var character_body = $CharacterBody2D
var bullet_impact_scene = preload("res://Scenes/SupportScenes/bullet_impact.tscn") as PackedScene

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.top_level = true

func _physics_process(delta):
	if progress_ratio == 1.0:
		emit_signal("on_base_damage", base_damage)
		queue_free()
	move(delta)

func move(delta):
	set_progress(get_progress() + speed * delta)
	health_bar.position = position - Vector2(health_bar.size.x / 2, 35)

func on_hit(damage):
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()

func impact():
	# randomize()
	var x_pos = randi() % 31
	var y_pos = randi() % 31
	var impact_location = Vector2(x_pos, y_pos)
	var impact = bullet_impact_scene.instantiate()
	impact.position = impact_location
	impact_area.add_child(impact)

func on_destroy():
	character_body.queue_free()
	await get_tree().create_timer(0.2).timeout
	queue_free()
