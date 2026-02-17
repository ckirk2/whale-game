class_name InteractRay
extends RayCast3D
@export var PROMT: Label

var CURRENT_COLLIDER

func _process(_delta: float) -> void:
	PROMT.text = ""
	
	if is_colliding():
		#collider will be of type Interactable_Object
		var collider = get_collider()

		if collider is InteractableObject:
			#Set CURRENT_COLLIDER so we can unhighlight later
			CURRENT_COLLIDER = collider
			PROMT.text = collider.get_prompt()
			collider.outline_obj() #set highlighting = true

			if Input.is_action_just_pressed(collider.PROMT_INPUT):
				#Owner because the player owns the intersect_ray which this script is attached to
				collider.player_interact(owner)
				collider.un_outline_obj()

	#when we stop looking at the object un-highlight
	#Because we delete the object, check that the object is valid and exists first
	elif (is_instance_valid(CURRENT_COLLIDER) and CURRENT_COLLIDER is InteractableObject):
		CURRENT_COLLIDER.un_outline_obj()
		#Clear CUR_COL so we don't keep running this loop
		CURRENT_COLLIDER = null

func disable_interact_ray() -> void:
	set_collision_mask_value(2, false)

func enable_interact_ray() -> void:
	set_collision_mask_value(2, true)
