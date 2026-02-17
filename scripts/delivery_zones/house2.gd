extends DeliveryZone


func _on_delivered(package: DeliverableObject) -> void:
	
	var temp_debug_string = "\n\nPackage: %s, \nDelivered at zone: %s\n\n"
	var out_string = temp_debug_string % [package, self]
	print_debug(out_string)
	
	var parent_obj = package.get_parent_obj()
	parent_obj.linear_velocity = Vector3(0,10,0)
