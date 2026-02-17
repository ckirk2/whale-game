class_name DeliverableObject
extends Node

@export var Package: Node3D
var being_held: bool = false


"""
Custom class to define deliverable objects. 
	DeliverableObjects interact with DeliveryZones. 
"""
func delete_pacakge() -> void:
	#DO something that doesn't just delete the object
	Package.queue_free()

func check_held() -> bool:
	return Package.being_held


func get_parent_obj() -> Node3D:
	return Package
