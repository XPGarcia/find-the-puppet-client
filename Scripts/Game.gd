extends Node2D

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")

onready var left_side = get_node("LeftSide")
onready var right_side = get_node("RightSide")

onready var end_game = get_node("EndGame")
onready var win_label = get_node("EndGame/Sprite/WinLabel")

func _ready():
	events.connect("game_updated", self, "_on_update")
	events.connect("voting_on_going", self, "_on_update")

func _on_update():
	if player_vars.status == "DEMOCRATS_WON":
		_update_screen()
		win_label.text = "Los demócratas ganaron"
	elif player_vars.status == "FASCISTS_WON":
		_update_screen()
		win_label.text = "Los fascistas ganaron"

func _update_screen():
	left_side.visible = false
	right_side.visible = false
	end_game.visible = true


func _on_NewGameButton_pressed():
	var _scene = get_tree().change_scene("res://Scenes/StartMenu.tscn")
