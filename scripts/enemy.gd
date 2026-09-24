extends CharacterBody3D

@export var health := 3
@export var enemy_bullet_scene: PackedScene
@export var min_shoot_interval := 1.5
@export var max_shoot_interval := 3.0
@export var gravity := 20.0

@onready var marker: Marker3D = $Marker3D

var shoot_timer := 0.0


func _ready():
	shoot_timer = randf_range(min_shoot_interval, max_shoot_interval)


func take_damage(amount):
	health -= amount

	if health <= 0:
		die()


func die():
	ScoreManager.add_score(100)
	queue_free()


func shoot():
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	var direction = (
		player.global_position - marker.global_position
	).normalized()

	var bullet = enemy_bullet_scene.instantiate()

	get_tree().current_scene.add_child(bullet)

	bullet.global_position = marker.global_position
	bullet.direction = direction


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

	move_and_slide()

	var player = get_tree().get_first_node_in_group("player")

	if player:
		var direction = player.global_position - global_position
		direction.y = 0

		if direction.length() > 0:
			look_at(
				global_position + direction,
				Vector3.UP
			)

	shoot_timer -= delta

	if shoot_timer <= 0:
		shoot()
		shoot_timer = randf_range(
			min_shoot_interval,
			max_shoot_interval
		)
