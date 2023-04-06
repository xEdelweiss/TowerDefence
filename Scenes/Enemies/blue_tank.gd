extends PathFollow2D

var speed = 150

func _physics_process(delta):
	move(delta)

func move(delta):
	set_progress(get_progress() + speed * delta)