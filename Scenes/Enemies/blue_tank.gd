extends PathFollow2D

var speed = 150
var hp = 50

@onready var health_bar = $HealthBar

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.top_level = true

func _physics_process(delta):
	move(delta)

func move(delta):
	set_progress(get_progress() + speed * delta)
	health_bar.position = position - Vector2(health_bar.size.x / 2, 35)

func on_hit(damage):
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()
		
func on_destroy():
	queue_free()
