class_name PlayerCharacter
extends CharacterBody3D

#editable variables
@export var pivot_point : Node3D
@export var CAMERA : Camera3D
@export_range(0,100) var CAMERA_SENSITIVITY : float = 20
@export_range(0,100) var ZOOM_SENSITIVITY : float = 2.5
@export var MOVEMENT_LOCKED : bool = false
@export var SPEED: float
@export var CHARGE_TIMER: Timer
@export var THROW_BAR: ProgressBar
@export var CAMERA_LOCKED: bool = false
@export var mouseController: MouseController
var camera_sensitivity: float
var holding_box: bool = false
var pickup_distance: Vector3 = Vector3(0,0,-1.5)
const pickup_lerp: float = 0.05
var held_object = null
var charge_ratio: float = 0.0

func _ready() -> void:
	camera_sensitivity = CAMERA_SENSITIVITY/10000
	THROW_BAR.hide()

func _process(_delta: float) -> void:
	if held_object:
		var camera_transform = self.CAMERA.global_transform
		held_object.global_transform = held_object.global_transform.interpolate_with(camera_transform.translated_local(pickup_distance), pickup_lerp)
		check_for_throw()

#func _unhandled_input(event: InputEvent) -> void:


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if !MOVEMENT_LOCKED:
		if not is_on_floor():
			velocity += get_gravity() * delta
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		var direction = (pivot_point.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			
		move_and_slide()

func pickup_package(package: InteractableObject):
	"""
	Handles the interact function for packages, re-parents object to self
	Args:
		-package: InteractableObject
	"""
	if !holding_box:
		holding_box = true
		held_object = package
		package.reparent(self, true)

func throw_package(package: InteractableObject, throw_velocity: Vector3= Vector3.ZERO):
	"""
	Handles throwing/dropping package
	Args:
		-package: InteractableObject
	"""
	if holding_box:
		package.throw(throw_velocity)
		holding_box = false
		held_object = null
	

func check_for_throw() -> void: 
	"""
	Function responsible for handling throwing inputs, timer, and UI elements
	"""
	if Input.is_action_just_released("throw"):
		charge_ratio = (CHARGE_TIMER.wait_time-CHARGE_TIMER.time_left)/CHARGE_TIMER.wait_time
		if charge_ratio<0.05:
			throw_package(held_object)
		CHARGE_TIMER.stop()
		var forward_vector = -CAMERA.get_global_transform().basis.z
		forward_vector = forward_vector.normalized()*charge_ratio
		throw_package(held_object, forward_vector)
		THROW_BAR.value = 0.0
		THROW_BAR.hide()

	if  Input.is_action_just_pressed("throw"):
		CHARGE_TIMER.start()
		
	if Input.is_action_pressed("throw"):
		charge_ratio = (CHARGE_TIMER.wait_time-CHARGE_TIMER.time_left)/CHARGE_TIMER.wait_time
		if charge_ratio > 0.05 and not THROW_BAR.visible:
			THROW_BAR.show()
		THROW_BAR.value = charge_ratio*100


func reset_player_state() -> void:
	"""
	Reset all transforms to 0
	"""
	self.rotation=Vector3.ZERO
	self.pivot_point.rotation_degrees=Vector3(0,180,0)
	CAMERA.rotation=Vector3.ZERO
