extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	print("musica")
	$soundtrack.play()

func _on_audio_stream_player_finished():
	print("musica")
	$soundtrack.play()
