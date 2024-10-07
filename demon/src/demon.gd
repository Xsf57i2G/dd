extends CharacterBody3D

signal died

var carrying = false
var acceleration = 15.0
var damage = 1
var dead = false
var friction = 5.0
var hp = 3
var speed = 2.0
var stunned = false

var gib = preload("res://item/gib.tscn")

func _physics_process(delta):
	if dead or stunned:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	var input = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)

		$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(-velocity.x, -velocity.z), speed * delta)
		$Armature.rotation.z = lerp($Armature.rotation.z, -direction.x * 0.1, speed * delta)

		if Input.is_action_pressed("Run"):
			$AnimationPlayer.play("Run")
			speed = 7.0
		elif carrying:
			print("carry")
			$AnimationPlayer.play("Carry")
		else:
			$AnimationPlayer.play("Walk")
			speed = 4.0

		var speed_scale = velocity.length() / 2.0
		if speed_scale > 0:
			$AnimationPlayer.speed_scale = speed_scale
			$Step/Timer.wait_time = 0.5 / speed_scale

		if $Step/Timer.is_stopped():
			$Step/Timer.start()
			$Step.play()
	else:
		if carrying:
			$AnimationPlayer.play("Carry")
		else:
			$AnimationPlayer.play("Idle")
		$AnimationPlayer.speed_scale = 1.0
		$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(-velocity.x, -velocity.z), speed * delta)
		$Armature.rotation.z = 0.0

		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.z = lerp(velocity.z, 0.0, friction * delta)

	if Input.is_action_just_pressed("Throw"):
		throw()
	if Input.is_action_just_pressed("Use"):
		interact()
	if Input.is_action_just_pressed("Interact"):
		interact()
	if Input.is_action_just_pressed("Dash"):
		dash()

	move_and_slide()

func hit(n):
	if not $Invulnerability.is_stopped():
		return
	else:
		$Invulnerability.start()
	$Hurt.play()
	$Blood.emitting = true
	hp -= n
	if hp <= 0:
		die()

func heal(n):
	hp += n

func die():
	dead = true
	died.emit()

	$Blood.emitting = true
	$AnimationPlayer.play("Death")

	add_child(gib.instantiate())

func stun():
	stunned = true

func dash():
	pass

func punch():
	if $Armature/Skeleton3D/RayCast3D.is_colliding():
		var body = $Armature/Skeleton3D/RayCast3D.get_collider()
		body.hit(damage)
		$Armature/Skeleton3D/RayCast3D.force_raycast_update()

func interact():
	var bodies = $Armature/Skeleton3D/Inventory.get_overlapping_bodies()
	if bodies.size() > 0:
		$Armature/RemoteTransform3D.remote_path = bodies[0].get_path()
		carrying = true
		var body = get_node($Armature/RemoteTransform3D.remote_path)
		if body and body.has_method("use"):
			body.held = true
			body.apply_central_impulse($Armature/Skeleton3D.global_transform.basis.z * -10)
	else:
		$Armature/RemoteTransform3D.remote_path = ""

func throw():
	var body = get_node($Armature/RemoteTransform3D.remote_path)
	if not body:
		return
	if body.has_method("stun"):
		body.stun()
	body.apply_central_impulse($Armature/Skeleton3D.global_transform.basis.z * -10)
	$Armature/RemoteTransform3D.remote_path = ""
