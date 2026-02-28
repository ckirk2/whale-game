extends Node3D

var amount: float = 1.0
var speed: float = 0.6
var noise_height_scale: float = 1.75
var current_time : float = 0.0
var distance_from_shore_factor: float = 50
var wave_frequency: float = 1.0
var height_scale: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

	
func generateOffset(x, z, val1, val2, time):
	var radiansX = ((fmod(x + z * x * val1, amount) / amount) + (time * speed) * fmod(x * 0.8 + z, 1.5)) * 2.0 * 3.14
	var radiansZ = ((fmod(val2 * (z * x + x * z), amount) / amount) + (time * speed) * 2.0 * fmod(x, 2.0)) * 2.0 * 3.14

	return amount * 0.5 * (sin(radiansZ) * cos(radiansX))
