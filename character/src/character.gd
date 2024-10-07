extends RigidBody3D

var carried = false
var dead = false
var hp = 3
var speed = 3.5
var stunned = false
var target = null

func hit(n):
	if not $Invulnerability.is_stopped():
		return
	else:
		$Invulnerability.start()
	$Hurt.play()
	hp -= n
	if hp <= 0:
		die()

func stun():
	stunned = true

func wander():
	pass

func die():
	dead = true

func _on_wake_timeout():
	stunned = false
