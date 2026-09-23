extends CharacterBody3D

@export var health := 3
@export var enemy_bullet_scene: PackedScene
@export var shoot_interval := 2.0

@onready var marker: Marker3D = $Marker3D

var shoot_timer := 0.0


func take_damage(amount):
	health -= amount

	if health <= 0:
		die()


func die():
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


func _process(delta):
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
		shoot_timer = shoot_interval
