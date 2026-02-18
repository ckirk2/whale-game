class_name MouseController
extends Node
var CAMERA_LOCKED: bool = false

@export var xPivot: Node3D
@export var yPivot: Node3D
@export var cameraSensitivity: float = 20

func _ready() -> void:
	cameraSensitivity = cameraSensitivity/10000

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		#If player clicks in window, remove MOUSE cursor
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	elif event.is_action_pressed("ui_cancel"):
		#If esc pressed show MOUSE
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED && !CAMERA_LOCKED:
		if event is InputEventMouseMotion:
			#Rotates in radians, so multiply by small factor (sensitivity) since MOUSE moves in num of pixels
			yPivot.rotate_y(-event.relative.x * cameraSensitivity)
			xPivot.rotate_x(-event.relative.y * cameraSensitivity)
			xPivot.rotation.x = clamp(xPivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
