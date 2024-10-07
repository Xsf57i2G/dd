extends StaticBody3D

var carried = false
var hp = 1

func hit(n):
	hp -= n
	if hp <= 0:
		queue_free()
