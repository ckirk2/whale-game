class_name MonsterHitBox
extends Node

@export var hurtBox: Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtBox.area_entered.connect(_on_area_entered)
	hurtBox.set_collision_mask_value(5, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_entered(area: Area3D) -> void:
	if area is Projectile:
		area.get_parent().freeze = true
		print_debug("Target: %s, Hit by: %s"% [self, area.get_parent()])
		#area.stop_lifetime()
