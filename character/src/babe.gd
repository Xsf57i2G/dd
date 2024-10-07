extends "res://character/src/character.gd"

var tired = false

func attack():
	rotate_y(deg_to_rad(25))

func _on_animation_player_animation_finished(_anim_name):
	pass

func _on_timer_timeout():
	tired = false
	$AnimationPlayer.play("Idle")

func _on_animation_player_current_animation_changed(_name):
	$Skeleton3D.reset_bone_poses()
