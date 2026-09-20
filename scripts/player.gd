extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 5.0

const BULLET_SCENE = preload("res://scenes/bullet.tscn")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera_pivot = $CameraPivot
@onready var muzzle = $Muzzle

func _ready():
	print("Marker:", $Muzzle)
	print("CameraPivot:", $CameraPivot)

func _input(event):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("kabummm")
			shoot()

func shoot():

	var bullet = BULLET_SCENE.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.global_position = muzzle.global_position

	bullet.direction = Vector3.LEFT

	print("Tiro criado")
func _physics_process(delta):

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var dir = Vector3.ZERO

	if Input.is_key_pressed(KEY_D):
		dir.z -= 1

	if Input.is_key_pressed(KEY_A):
		dir.z += 1

	if Input.is_key_pressed(KEY_W):
		dir.x -= 1

	if Input.is_key_pressed(KEY_S):
		dir.x += 1

	dir = dir.normalized()

	velocity.x = dir.x * SPEED
	velocity.z = dir.z * SPEED

	move_and_slide()

	if global_position.y < -10:
		get_tree().reload_current_scene()
