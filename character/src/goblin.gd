extends "res://character/src/character.gd"

@onready var mesh = $MeshInstance3D.mesh

var armored = false
var reach = 2.0

func _physics_process(delta):
	if dead:
		return
	if stunned:
		if $Wake.is_stopped():
			$Wake.start()
		return

	var bodies = $Area3D.get_overlapping_bodies()
	for body in bodies:
		target = body
		break
	if not bodies:
		return

	if target:
		if reach > position.distance_to(target.position):
			pass
		else:
			var direction = (target.position - position).normalized()
			position = position.lerp(position + direction * speed, delta)

			if $Step/Timer.is_stopped():
				$Step/Timer.start()

				$Step.play()

func hit(n):
	if armored:
		$Timer.start()
		return

	super.hit(n)

func attack():
	target.hit(1)

func _on_armored_timeout():
	armored = false
