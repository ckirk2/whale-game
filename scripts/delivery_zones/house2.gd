extends DeliveryZone


func _on_delivered(delivered_package: DeliverableObject) -> void:
	
	var temp_debug_string = "\n\nPackage: %s, \nDelivered at zone: %s\n\n"
	var out_string = temp_debug_string % [delivered_package, self]
	print_debug(out_string)
	
	var parent_obj = delivered_package.get_parent_obj()
	parent_obj.linear_velocity = Vector3(0,10,0)
