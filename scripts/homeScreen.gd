extends Control

func _ready():
	print($soundtrack)
	$soundtrack.play()
	$jogar.pressed.connect(_on_jogar_pressed)
	$sair.pressed.connect(_on_sair_pressed)

func _on_jogar_pressed():
	print("clicou")
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_sair_pressed():
	get_tree().quit()
