extends DeliveryZone


func _on_delivered(package:DeliverableObject) -> void:
	"""
	Links the 'delivered()' signal of the parent DeliveryZone class to handle
	the package. 
	Can be replaced later with animations/interactions
	"""
	var temp_debug_string = "\n\nPackage: %s, \nDelivered at zone: %s\n\n"
	var out_string = temp_debug_string % [package, self]
	print_debug(out_string)
	package.delete_pacakge()
