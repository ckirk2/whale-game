extends InteractableObject
@export var X_PIVOT: Node3D
@export var Y_PIVOT: Node3D
@export var PLAYER_HOLD_POINT: Node3D
@export var INTERACT_RACE_TIMER: Timer
@export var PLAYER_LEAVE: Node3D
@export var mouseController: HardpointMouseController
@export var harpoonShootLoation: Node3D
@export var harpoon: RigidBody3D

var on_hardpoint: bool = false
var player: PlayerCharacter
var harpoonLoaded: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouseController.CAMERA_LOCKED = true
	harpoon.hide()
	harpoon.freeze = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if on_hardpoint:
		if Input.is_action_just_pressed("interact") && INTERACT_RACE_TIMER.is_stopped():
			undock_from_hardpoint()


func _unhandled_input(event: InputEvent) -> void:
	if on_hardpoint:
		mouseController.handle_mouse(event, player)


func _on_interacted(body: Variant) -> void:
	if body is PlayerCharacter:
		player = body
		body.MOVEMENT_LOCKED = true
		body.mouseController.CAMERA_LOCKED = true
		body.reset_player_state()
		body.global_transform = PLAYER_HOLD_POINT.global_transform
		on_hardpoint = true
		INTERACT_RACE_TIMER.start()
		mouseController.CAMERA_LOCKED = false
		disable_interact()	
		
func undock_from_hardpoint() -> void:
	player.MOVEMENT_LOCKED = false
	player.mouseController.CAMERA_LOCKED = false
	on_hardpoint = false
	enable_interact()


func shoot() -> void:
	if harpoonLoaded:
		var forward_vector = harpoonShootLoation.get_global_transform().basis.z
		for child in harpoon.get_children():
			if child is Projectile:
				harpoon.linear_velocity = forward_vector*child.fireVelocity
				child.enable_collision()
				child.start_lifetime()
		harpoon.top_level = true
		harpoon.freeze = false
		harpoonLoaded = false
	
	
func reload() -> void:
	if !harpoonLoaded:
		harpoon.freeze = true
		harpoon.reparent(harpoonShootLoation)
		for child in harpoon.get_children():
			if child is Projectile:
				child.stop_lifetime()
		harpoon.global_position = harpoonShootLoation.global_position
		harpoon.rotation = harpoonShootLoation.rotation
		harpoonLoaded = true
		harpoon.show()
