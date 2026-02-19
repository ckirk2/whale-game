class_name HardpointMouseController
extends Node
var CAMERA_LOCKED: bool = false

@export var xPivot: Node3D
@export var yPivot: Node3D
@export var cameraSensitivity: float = 20
@export var playerHoldPoint: Node3D
@export var hardPoint: Node3D

func _ready() -> void:
	cameraSensitivity = cameraSensitivity/10000

func handle_mouse(event: InputEvent, player: PlayerCharacter) -> void:
		if event is InputEventMouseButton:
			#If player clicks in window, remove MOUSE cursor
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		elif event.is_action_pressed("ui_cancel"):
			#If esc pressed show MOUSE
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:	
			if event is InputEventMouseMotion:
				yPivot.rotate_y(-event.relative.x *cameraSensitivity)
				xPivot.rotate_x(event.relative.y * cameraSensitivity)
				xPivot.rotation.x = clamp(xPivot.rotation.x, deg_to_rad(-45), deg_to_rad(70))
				yPivot.rotation.y = clamp(yPivot.rotation.y, deg_to_rad(-70), deg_to_rad(70))
				player.global_transform=playerHoldPoint.global_transform
			if Input.is_action_just_pressed("right_click"):
				var tween := create_tween()
				tween.tween_property(player.CAMERA, "fov", 35, 0.15)
				#player.CAMERA.fov = 35
			if Input.is_action_just_released("right_click"):
				var tween := create_tween()
				tween.tween_property(player.CAMERA, "fov", 90, 0.15)
				
		if Input.is_action_just_pressed("reload"):
			hardPoint.reload()
			
		if Input.is_action_just_pressed("left_click"):
			hardPoint.shoot()
		
