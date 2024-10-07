@tool
extends EditorScenePostImport

func _post_import(scene):
	iterate(scene)
	return scene

func iterate(node):
	if node:
		for child in node.get_children():
			iterate(child)