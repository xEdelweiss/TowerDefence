extends AnimatedSprite2D

func _ready():
	play("impact")

func _on_animation_finished():
	queue_free()
