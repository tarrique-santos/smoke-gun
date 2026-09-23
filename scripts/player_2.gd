
extends CharacterBody3D

@export var speed := 10.0
@export var gravity := 20.0
@export var jump_force := 12.0
@export var mouse_sensitivity := 0.003

@export var bullet_scene: PackedScene

@onready var camera_pivot: Node3D = $CameraPivot
@onready var marker: Marker3D = $CameraPivot/Marker3D

@export var health := 5
@export var invulnerability_time := 0.5

var invulnerable := false

var camera_yaw := 0.0
var camera_pitch := -0.3


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_yaw = rotation.y


func _input(event):
	if event is InputEventMouseMotion:
		camera_yaw -= event.relative.x * mouse_sensitivity
		camera_pitch -= event.relative.y * mouse_sensitivity

		camera_pitch = clamp(camera_pitch, -1.4, 1.4)

		rotation.y = camera_yaw

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot()


func _process(_delta):
	camera_pivot.rotation = Vector3(
		camera_pitch,
		0,
		0
	)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
	else:
		velocity.y = 0

	var input = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	var direction = (
		camera_pivot.global_transform.basis.z * input.y +
		camera_pivot.global_transform.basis.x * input.x
	)

	direction.y = 0

	if direction.length() > 0:
		direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()


func shoot():
	if bullet_scene == null:
		return

	var camera = camera_pivot.get_node("Camera3D")

	var screen_center = get_viewport().get_visible_rect().size * 0.5

	var ray_origin = camera.project_ray_origin(screen_center)
	var ray_direction = camera.project_ray_normal(screen_center)

	var query = PhysicsRayQueryParameters3D.create(
		ray_origin,
		ray_origin + ray_direction * 1000.0
	)

	query.exclude = [self]

	var result = get_world_3d().direct_space_state.intersect_ray(query)

	var target_position = ray_origin + ray_direction * 1000.0

	if result:
		target_position = result.position

	var shoot_direction = (
		target_position - marker.global_position
	).normalized()

	var bullet = bullet_scene.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.global_position = marker.global_position
	bullet.direction = shoot_direction

func take_damage(amount):
	if invulnerable:
		return

	health -= amount

	if health <= 0:
		die()
		return

	invulnerable = true

	await get_tree().create_timer(invulnerability_time).timeout

	invulnerable = false


func die():
	queue_free()
