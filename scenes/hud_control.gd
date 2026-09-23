extends Control

@onready var player = get_tree().get_first_node_in_group("player")
@onready var vida_label = $Vida


func _process(_delta):
	if is_instance_valid(player):
		vida_label.text = "Vida: " + str(player.health) + "/5"
	else:
		hide()
