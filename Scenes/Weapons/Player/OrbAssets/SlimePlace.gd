extends Sprite

export var SLOW_DIV = 2

func _ready():
	global_rotation_degrees = rand_range(0, 360)
	scale *= rand_range(0.8, 1.2)

func _on_Timer_timeout():
	queue_free()
