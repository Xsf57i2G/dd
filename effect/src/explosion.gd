extends Area3D

var damage = 3

func _physics_process(_delta):
	position += Vector3(0, 0.03, 0)

	for body in get_overlapping_bodies():
		body.hit(damage)

func _on_timer_timeout():
	get_parent().queue_free()
