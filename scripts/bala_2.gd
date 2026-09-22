extends Area3D

@export var speed := 120.0
@export var lifetime := 3.0

var direction := Vector3.ZERO


func _ready():
	body_entered.connect(_on_body_entered)

	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _physics_process(delta):
	global_position += direction * speed * delta

	if direction.length() > 0:
		look_at(
			global_position + direction,
			Vector3.UP
		)


func _on_body_entered(_body):
	queue_free()
