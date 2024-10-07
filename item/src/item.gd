extends RigidBody3D

func _process(_delta):
	if position.y <= 0:
		position.y = 0
