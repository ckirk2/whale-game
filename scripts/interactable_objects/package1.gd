extends InteractableObject

@export var PACKAGE_MASS: float = 1.0
@export var MAX_VELOCITY: float = 10.0

var original_parent: Node3D
var being_held: bool = false

var _previous_position = Vector3.ZERO
var _current_position = Vector3.ZERO
var _velocity = Vector3.ZERO

func _ready() -> void:
	"""
	Initialization function:
		Sets parent from scene tree
		Sets initial position for velocity
		Calculates max velocity based on weight
	"""
	# Get the parent node so we can re-parent during throw()
	original_parent = self.get_parent()
	# Set initial position for velocity calc later
	_previous_position = global_position
	MAX_VELOCITY = MAX_VELOCITY/PACKAGE_MASS
	self.mass = PACKAGE_MASS

func _physics_process(delta: float) -> void:
	"""
	Physics process:
		Calculates velocity for throw/drop interaction
	"""
	if being_held:
		_current_position = global_position
		_velocity = (_current_position - _previous_position) / delta
		_previous_position = global_position


func _on_interacted(body: Variant) -> void:
	"""
	Interact function for the Package body
	
	Args:
		- body: any body that has a class funciton 'pickup_package'
	"""
	if body is PlayerCharacter:
		input_ray_pickable = false
		body.pickup_package(self)
		self.freeze = true
		disable_interact()
		set_collision_layer_value(3, false)
		being_held = true

func throw(velocity: Vector3 = Vector3.ZERO) -> void:
	"""
	Handles throwing interactions:
		Gets the global position, un-parents from holding body, re-parents to world,
		sets position, sets velocity, re-enables physics values
	"""
	var original_transform = self.global_transform
	self.get_parent().remove_child(self)
	original_parent.add_child(self)
	self.global_transform = original_transform
	
	#apply max velocity
	if velocity!=Vector3.ZERO:
		_velocity=velocity*MAX_VELOCITY
	else:
		if (_velocity.length()>MAX_VELOCITY):
			_velocity = _velocity.normalized()*MAX_VELOCITY
	self.linear_velocity = _velocity
	self.freeze = false
	enable_interact()
	set_collision_layer_value(3, true)
	being_held = false
