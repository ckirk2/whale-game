class_name InteractableObject
extends CollisionObject3D

signal interacted(body)

@export var PROMT_MESSAGE = "Interact"
@export var PROMT_INPUT = "interact" #Aligns with input_map name | interact -> E
@export var OUTLINE_MATERIAL: Material
@export var MESH_LIST: Array[MeshInstance3D]

func _ready() -> void:
	un_outline_obj()

func get_prompt():
	"""
	Gets the input key and displays prompt message when colliding with interact ray
	"""
	var key_name = ""
	for action in InputMap.action_get_events(PROMT_INPUT):
		if action is InputEventKey:
			key_name = action.as_text_physical_keycode()
			break

	return PROMT_MESSAGE + "\n[" +key_name + "]"
	
func player_interact(body):
	"""
	Emits the interact signle, to be handled by the Interactable Object
	Args:
		-body: any Node3D for the time being
	"""
	interacted.emit(body)

func outline_obj() -> void:
	"""
	Applies the `simple_outline` resource to all assigned meshes
	"Mesh List" should be set in the inspector to the "MeshInstace3D" that you want to highlight
	"""
	for mesh in MESH_LIST:
		mesh.material_overlay = OUTLINE_MATERIAL
		
func un_outline_obj() -> void:
	"""
	outline_obj() but in reverse
	"""
	for mesh in MESH_LIST:
		mesh.material_overlay = null

func disable_interact() -> void: #not used in anything rn
	"""
	Disables the collision layer 2 so this isn't detectable by the interact ray
	"""
	set_collision_layer_value(2, false)

func enable_interact() -> void: #not used in anything rn
	"""
	Enables the collision layer 2 so this is detectable by the interact ray
	"""
	set_collision_layer_value(2, true)
