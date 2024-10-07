extends "res://item/src/item.gd"

var loot = [
	preload("res://item/bomb.tscn"),
]

func open():
	var item = loot.pick_random().instantiate()

	item.position = Vector3.UP

	get_parent().add_child(item)

func _on_area_3d_body_entered(_body):
	open()
