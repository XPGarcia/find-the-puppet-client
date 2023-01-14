extends Node2D

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

onready var title_label = get_node("VotingPanel/Board/TitleLabel")
onready var players_container = get_node("VotingPanel/Board/Players")
onready var omit_button = get_node("VotingPanel/Board/OmitButton")

var initial_x_position = 50
var initial_y_position = 50
var x_padding = 150
var y_padding = 150


func _ready():
	_set_player_profiles()

func _filter_players():
	var player_list = []
	for player in player_vars.game.players:
		if player.playerId == player_vars.playerId:
			continue
		player_list.append(player)
	return player_list
		
func _set_player_profiles():
	_clear_profiles()
	var player_list = _filter_players()
	for i in len(player_list):
		var player = player_list[i]
		var profile_scene = _load_player_profile(player)
		_set_profile_texture(profile_scene, player)
		_set_profile_position(profile_scene, i)
		players_container.add_child(profile_scene)
		
func _clear_profiles():
	for profile_node in players_container.get_children():
		players_container.remove_child(profile_node)
		profile_node.queue_free()

func _load_player_profile(player):
	var profile_scene = load("res://Scenes/ProfileImage.tscn").instance()
	profile_scene.set_player(player)
	return profile_scene
		
func _set_profile_texture(profile_scene, player):
	var profile_texture = load("res://Assets/" + player.playerProfile)
	profile_scene.set_texture(profile_texture)
	profile_scene.scale = Vector2(0.1, 0.1)
	profile_scene.get_node("SelectedButton").visible = true
	profile_scene.get_node("Name").visible = true
	profile_scene.get_node("Name").text = player.playerName

func _set_profile_position(profile_scene, index):
	var profiles_per_row = 4
	var x_position = initial_x_position
	var y_position = initial_y_position

	if index < profiles_per_row:
		x_position = x_position + (x_padding * index)
		y_position = initial_y_position
	else:
		x_position = initial_x_position + (y_padding * (index - profiles_per_row))
		y_position = initial_y_position + y_padding
	var position = Vector2(x_position, y_position)
	profile_scene.set_position(position)
