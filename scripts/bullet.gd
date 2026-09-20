extends Area3D

const SPEED = 15.0
const MAX_DISTANCE = 100.0

var direction = Vector3.ZERO
var start_position = Vector3.ZERO

func _ready():
	
	start_position = -global_position

func _process(delta):

	global_position += direction * SPEED * delta

	if global_position.distance_to(start_position) >= MAX_DISTANCE:
		queue_free()
