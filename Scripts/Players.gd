extends Node2D

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")

onready var player1 = get_node("ProfileImage1")
onready var player2 = get_node("ProfileImage2")
onready var player3 = get_node("ProfileImage3")
onready var player4 = get_node("ProfileImage4")

onready var player_containers = [player1, player2, player3, player4]

func _ready():
	events.connect("game_updated", self, "_on_update")
	
func _on_update():
	var player_in_turn_index = player_vars.get_player_in_turn_index()
	for i in range(0, 4):
		var player = player_vars.game.players[player_in_turn_index]
		_set_player_container(player_containers[i], player)
		player_in_turn_index = _new_player_in_turn_index(player_in_turn_index)
		
func _set_player_container(player_container, player):
	var sprite = load("res://Assets/players/" + player.playerProfile)
	player_container.set_texture(sprite)
	player_container.get_node("Name").visible = true
	player_container.get_node("Name").text = player.playerName
	
func _new_player_in_turn_index(player_in_turn_index):
	if player_in_turn_index < len(player_vars.game.players) - 1:
		return player_in_turn_index + 1
	else:
		return 0
