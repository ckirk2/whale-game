class_name DeliveryZone
extends CollisionObject3D


"""
Custom class to define delivery zones.
	DeliveryZones primarily interact with DeliverableObjects 
	
Common params:
	DELIVERY_TIMER: Assigned in the inspector to change the amount of time to wait to accept a package
	timer_started: Used in the _process() func to check for valid delivery conditions
	package: DeliverableObject that the zone interacts with
	CheckDeliveryParams: triggered when a DeliverableObject is within the delivery zone
	
	
Signal:
	delivered(): Raised when conditions for a delivery are met -> to be handled by each independent delivery zon
"""
@export var DELIVERY_TIMER: Timer

var timer_started: bool = false
var package: DeliverableObject
var CheckDeliveryParams: bool = false

signal delivered(package:DeliverableObject)


func _process(_delta: float) -> void:
	if CheckDeliveryParams:
		if !package.check_held():
			if !timer_started:
				DELIVERY_TIMER.start()
				timer_started = true
			if DELIVERY_TIMER.time_left == 0:
				delivered.emit(package)


func _on_area_entered(area: Node) -> void:
	"""
	Checks if the area that has entered is of type DeliverableObject and sets values
	accordingly
	"""
	if area is DeliverableObject: #TODO check that the area is also the package we're expecting here
		package = area
		CheckDeliveryParams = true


func _on_area_exited(area: Node) -> void:
	"""
	Checks if the area that has exited is of type DeliverableObject and sets values
	accordingly
	"""
	if area is DeliverableObject:
		package = null
		CheckDeliveryParams = false
		DELIVERY_TIMER.stop()
		timer_started = false
