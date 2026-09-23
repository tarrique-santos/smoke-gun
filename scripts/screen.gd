extends Control

@onready var botao = $Button

func _ready():
	botao.pressed.connect(reviver)

func reviver():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/main.tscn")
