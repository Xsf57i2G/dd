extends "res://item/src/item.gd"

var held = false
var explosion = preload("res://effect/explosion.tscn").instantiate()

func _process(_delta):
	if held:
		$AnimationPlayer.play("Bomb/Explode")

func explode():
	add_child(explosion)

func _on_fuse_timeout():
	explode()
