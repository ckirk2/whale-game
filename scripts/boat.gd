class_name Boat
extends CharacterBody3D

@export var TOP_SPEED: float = 5.0
@export var TOP_ROTATIONAL_SPEED: float = 2*3.14/6 # radians per second 
@export var LINEAR_ACCELLERATION : float = 1
@export var ROTATIONAL_ACCELERATION: float = 0.1
@export var WHEEL: Node3D

var PlayerDriving: bool = false
var rotation_speed: float = 0
var forward_velocity: float = 0

func _physics_process(delta: float) -> void:
	# The boat always drives
	var foward_vector = -global_transform.basis.z.normalized()
	velocity = foward_vector*forward_velocity
	velocity.y = 0
	rotate_y(rotation_speed*delta)
	move_and_slide()
	

func _unhandled_input(_event: InputEvent) -> void:
	if PlayerDriving:
		if Input.is_action_pressed("forward"):
			var tween_linear := create_tween()
			tween_linear.tween_property(self, "forward_velocity", forward_velocity - LINEAR_ACCELLERATION, 1)
		if Input.is_action_pressed("back"):
			var tween_linear := create_tween()
			tween_linear.tween_property(self, "forward_velocity", forward_velocity + LINEAR_ACCELLERATION, 1)
		if Input.is_action_pressed("left"):
			var tween_roational := create_tween()
			tween_roational.tween_property(self, "rotation_speed", rotation_speed+ROTATIONAL_ACCELERATION, 1)
			var wheel_tween := create_tween()
			wheel_tween.tween_property(WHEEL, "rotation", WHEEL.rotation+Vector3(0,0,-10/3.14), 0.5)
		if Input.is_action_pressed("right"):
			var tween_roational := create_tween()
			tween_roational.tween_property(self, "rotation_speed", rotation_speed-ROTATIONAL_ACCELERATION, 1)
			var wheel_tween := create_tween()
			wheel_tween.tween_property(WHEEL, "rotation", WHEEL.rotation+Vector3(0,0,10/3.14), 0.5)
			
		forward_velocity = clamp(forward_velocity,-TOP_SPEED, TOP_SPEED)
		rotation_speed = clamp(rotation_speed, -TOP_ROTATIONAL_SPEED, TOP_ROTATIONAL_SPEED)
