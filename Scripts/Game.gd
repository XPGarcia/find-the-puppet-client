extends Node2D

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

onready var left_side = get_node("LeftSide")
onready var right_side = get_node("RightSide")

onready var end_game = get_node("EndGame")
onready var win_label = get_node("EndGame/Sprite/WinLabel")

onready var eliminated = get_node("Eliminated")
onready var player_election = get_node("PlayerElection")

func _ready():
	events.connect("game_updated", self, "_on_update")
	events.connect("voting_on_going", self, "_on_update")

func _on_update():
	if player_vars.status == "DEMOCRATS_WON":
		_update_end_game_screen()
		win_label.text = "Los demócratas ganaron"
	elif player_vars.status == "FASCISTS_WON":
		_update_end_game_screen()
		win_label.text = "Los fascistas ganaron"
	elif _is_eliminated_player():
		_update_eliminated_player_screen()
	elif player_vars.status == "ELIMINATE_VOTING" or player_vars.status == "PRESIDENT_VOTING" or player_vars.status == "WAITING_VOTING":
		_update_player_election_screen()
	else:
		_reset()

func _update_end_game_screen():
	left_side.visible = false
	right_side.visible = false
	eliminated.visible = false
	player_election = false
	
	end_game.visible = true
	
func _update_eliminated_player_screen():
	left_side.visible = false
	right_side.visible = false
	player_election = false
	
	eliminated.visible = true
	
func _is_eliminated_player():
	var is_eliminated = true
	for player in player_vars.game.players:
		if player.playerId == player_vars.playerId:
			is_eliminated = false
	player_vars.eliminated = is_eliminated
	return is_eliminated
	
func _update_player_election_screen():
	left_side.visible = false
	right_side.visible = false
	eliminated.visible = false
	
	player_election.visible = true
	
func _reset():
	left_side.visible = true
	right_side.visible = true
	eliminated.visible = false
	player_election.visible = false

func _on_NewGameButton_pressed():
	var _scene = get_tree().change_scene("res://Scenes/StartMenu.tscn")
