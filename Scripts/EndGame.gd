extends Node2D

onready var player_vars = get_node("/root/PlayerVariables")

onready var win_label = get_node("Sprite/WinLabel")

func _ready():
	if player_vars.status == "DEMOCRATS_WON":
		win_label.text = "Los demócratas ganaron"
	elif player_vars.status == "FASCISTS_WON":
		win_label.text = "Los fascistas ganaron"
	player_vars.reset()

func _on_NewGameButton_pressed():
	var _scene = get_tree().change_scene("res://Scenes/StartMenu.tscn")
