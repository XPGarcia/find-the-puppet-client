extends Node

onready var player_vars = get_node("/root/PlayerVariables")

func _on_Room_text_changed(new_text):
	player_vars.roomId = new_text


func _on_Name_text_changed(new_text):
	player_vars.playerName = new_text
