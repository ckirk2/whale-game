class_name Projectile
extends Area3D
@export var collisionShape: Area3D
@export var fireVelocity: float
@export var lifeTimeTimer: Timer

var flying: bool = false
var parent: Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	disable_collision()
	lifeTimeTimer.timeout.connect(_on_lifetime_timeout)
	parent = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if flying:
		parent.look_at(parent.global_position + parent.linear_velocity, Vector3.UP)

func enable_collision() -> void:
	collisionShape.set_collision_layer_value(1, true) # World
	collisionShape.set_collision_layer_value(3, true) # Environment
	collisionShape.set_collision_layer_value(5, true) # Monster Hurt box

func disable_collision() -> void:
	collisionShape.set_collision_layer_value(1, false) # World
	collisionShape.set_collision_layer_value(3, false) # Environment
	collisionShape.set_collision_layer_value(5, false) # Monster Hurt box

func start_lifetime() -> void:
	lifeTimeTimer.start()
	flying = true

func stop_lifetime() -> void:
	lifeTimeTimer.stop()
	flying = false
	
func _on_lifetime_timeout() -> void:
	self.get_parent().hide()
