@tool
extends Node3D

var over = false
var noise = FastNoiseLite.new()
var width = 64
var depth = 64
var voxels = [
	preload("res://world/stone.tscn"),
	preload("res://world/dirt.tscn"),
]
var bedrock = preload("res://world/bedrock.tscn")

func _ready():
	noise.seed = randi()
	noise.frequency = 0.1

	generate()

func _physics_process(delta):
	if over:
		$Demon/Pivot.rotate_object_local(Vector3.UP, 0.2 * delta)
		$WorldEnvironment.environment.fog_density = lerp($WorldEnvironment.environment.fog_density, 4.0, 0.1 * delta)
		$WorldEnvironment.environment.fog_depth_curve = lerp($WorldEnvironment.environment.fog_depth_curve, 5.0, 0.1 * delta)
		$WorldEnvironment.environment.fog_depth_begin = lerp($WorldEnvironment.environment.fog_depth_begin, 3.0, 0.1 * delta)

func generate():
	for x in width:
		for z in depth:
			if x == 0 or x == width - 1 or z == 0 or z == depth - 1:
				var edge_voxel = bedrock.instantiate()
				edge_voxel.position = Vector3(x + 0.5, 0, z + 0.5)
				add_child(edge_voxel)
				continue
			var ground = voxels.pick_random().instantiate()
			ground.position = Vector3(x + 0.5, -1, z + 0.5)
			add_child(ground)

			var n = noise.get_noise_2d(x, z)
			if n > 0.1:
				if abs(x - width / 2.0) < 4.0 and abs(z - depth / 2.0) < 4.0:
					continue

				for voxel in voxels:
					var v = voxel.instantiate()
					v.position = Vector3(x + 0.5, 0, z + 0.5)
					add_child(v)

func _on_demon_died():
	over = true
