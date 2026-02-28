extends InteractableObject

@export var BUOYANCE_POINTS: Array[Node3D] = []
@export var INTERACT_RACE_TIMER: Timer
@export var PLAYER_HOLD_POINT: Node3D
@export var BOAT: Boat

var player: PlayerCharacter
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if BOAT.PlayerDriving:
		player.global_transform=PLAYER_HOLD_POINT.global_transform
		if Input.is_action_just_pressed("interact") && INTERACT_RACE_TIMER.is_stopped():
			undock_from_hardpoint()


func _on_interacted(body: Variant) -> void:
	if body is PlayerCharacter:
		player = body
		body.MOVEMENT_LOCKED = true
		body.reset_player_state()
		body.global_transform = PLAYER_HOLD_POINT.global_transform
		BOAT.PlayerDriving = true
		INTERACT_RACE_TIMER.start()
		disable_interact()	


func undock_from_hardpoint() -> void:
	player.MOVEMENT_LOCKED = false
	BOAT.PlayerDriving = false
	enable_interact()
