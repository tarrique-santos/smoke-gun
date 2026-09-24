extends Control

@onready var player = get_tree().get_first_node_in_group("player")
@onready var spawner = get_tree().current_scene.get_node("EnemySpawner")

@onready var vida_label = $Vida
@onready var pontos_label = $Pontos
@onready var waves_label = $Waves


func _process(_delta):
	if is_instance_valid(player):
		vida_label.text = "Vida: " + str(player.health) + "/5"
	else:
		hide()
		return

	pontos_label.text = "Pontos: " + str(ScoreManager.score)

	if is_instance_valid(spawner):
		waves_label.text = "Wave: " + str(spawner.current_wave) + "/" + str(spawner.max_waves)
