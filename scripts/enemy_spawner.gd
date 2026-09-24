extends Node3D

@export var enemy_scene: PackedScene
@export var enemies_first_wave := 5
@export var enemies_per_wave := 2
@export var max_waves := 5

@export var min_spawn_distance_from_player := 10.0
@export var max_spawn_distance_from_player := 20.0
@export var min_spawn_distance := 5.0

@export var wave_delay := 3.0
@export var final_wave_delay := 5.0

var current_wave := 0
var spawning_wave := false
var game_finished := false


func _ready():
	add_to_group("enemy_spawner")
	start_next_wave()


func _process(_delta):
	if game_finished:
		return

	if not spawning_wave and get_child_count() == 0:
		if current_wave < max_waves:
			start_next_wave()
		else:
			finish_game()


func start_next_wave():
	current_wave += 1
	spawning_wave = true

	await get_tree().create_timer(wave_delay).timeout

	var amount = enemies_first_wave + (current_wave - 1) * enemies_per_wave

	for i in range(amount):
		spawn_enemy()

	spawning_wave = false


func spawn_enemy():
	var enemy = enemy_scene.instantiate()

	add_child(enemy)

	var spawn_position = get_spawn_position()

	enemy.position = spawn_position + Vector3(0, 2, 0)


func get_spawn_position():
	var attempts := 0

	while attempts < 100:
		var angle = randf_range(0, TAU)
		var distance = randf_range(
			min_spawn_distance_from_player,
			max_spawn_distance_from_player
		)

		var position = Vector3(
			cos(angle) * distance,
			0,
			sin(angle) * distance
		)

		var valid = true

		for enemy in get_children():
			if enemy is CharacterBody3D:
				if position.distance_to(enemy.position) < min_spawn_distance:
					valid = false
					break

		if valid:
			return position

		attempts += 1

	return Vector3(0, 0, max_spawn_distance_from_player)


func finish_game():
	game_finished = true

	await get_tree().create_timer(final_wave_delay).timeout

	get_tree().paused = true
