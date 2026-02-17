extends Node3D

@export var player: CharacterBody3D

#TODO Make grid size random and increase with level
const X_GRID_SIZE:int = 6
const Z_GRID_SIZE:int = 6
const TILE_SIZE: int = 20
const TOWN_TILE_PATH: String = "res://scenes/town_tiles"


func _ready() -> void:
	var my_scenes = get_town_tiles("res://scenes/town_tiles/")
	for x in X_GRID_SIZE:
		for z in Z_GRID_SIZE:
			var scene = my_scenes.pick_random()
			var instance = scene.instantiate()
			add_child(instance)
			instance.position = Vector3(x*TILE_SIZE, 0, z*TILE_SIZE)

	player.global_position = Vector3(10,2,10)


#TODO Change this to not have to load all the tiles everytime we run
# - json
# - resource file
func get_town_tiles(tile_path: String) -> Array:
	var dir = DirAccess.open(tile_path)
	var tile_paths = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				var full_path = tile_path+file_name
				tile_paths.append(load(full_path))
			file_name = dir.get_next()
	else:
		push_error("Could not open directory: " + tile_path)
	return tile_paths
