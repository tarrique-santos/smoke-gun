extends Control

@onready var botao_jogar = $Jogar
@onready var botao_sair = $Sair
@onready var pontos = $Pontos
@onready var high_score = $HighScore


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	botao_jogar.pressed.connect(reviver)
	botao_sair.pressed.connect(sair)

	pontos.text = "Pontos: " + str(ScoreManager.score)
	high_score.text = "High Score: " + str(ScoreManager.highscore)


func reviver():
	ScoreManager.reset_score()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func sair():
	get_tree().quit()
