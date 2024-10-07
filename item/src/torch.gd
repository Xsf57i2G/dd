extends "res://item/src/item.gd"

var noise = FastNoiseLite.new()
var time = 0.0

func _ready():
	noise.seed = randi()

func _process(delta: float):
	var value = noise.get_noise_1d(time)

	time += delta

	$Flame/OmniLight3D.light_energy = clamp(10 * abs(value), 5, 10)
