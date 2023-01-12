extends Node2D

onready var player_vars = get_node("/root/PlayerVariables")

func _ready():
	player_vars.eliminated = true

func _on_NewGameButton_pressed():
	player_vars.reset()
	var _scene = get_tree().change_scene("res://Scenes/StartMenu.tscn")
