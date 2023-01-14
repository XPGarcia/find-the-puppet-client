extends Node

signal player_selected()
signal end_action()

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

func activate_card(card):
	player_vars.has_played = true 
	player_vars.card_on_board = card
	if card.type == "law":
		_start_law_voting(card)
	elif card.type == "action":
		_start_action_card(card)
		yield(self, "end_action")
		_remove_card(card)

func _start_law_voting(card):
	var data = {
		"playerId": player_vars.playerId,
		"roomId": player_vars.roomId,
		"eventType": "voting",
		"action": "startLawVoting",
		"payload": {
			"player": {
				"playerId": player_vars.playerId,
				"playerName": player_vars.playerName,
				"playerProfile": player_vars.playerProfile
			},
			"card": card
		}
	}
	message_manager.send(data)
	
func _start_action_card(card):
	var data = {
		"playerId": player_vars.playerId,
		"roomId": player_vars.roomId,
		"eventType": "card",
		"action": "startAction",
		"payload": {
			"player": {
				"playerId": player_vars.playerId,
				"playerName": player_vars.playerName,
				"playerProfile": player_vars.playerProfile
			},
			"card": card
		}
	}
	message_manager.send(data)
	_execute_action(card)
	
func _execute_action(card):
	if card.code == "coup":
		_coup()
	elif card.code == "mkUltra":
		_mk_ultra()
	elif card.code == "corruptionInvestigation":
		_corruption_investigation()
	
func _coup():
	player_vars.game.playerAsPresident = player_vars.playerId
	player_vars.game_message = player_vars.playerName + " es el presidente"
	_update_game_in_server(player_vars.game_message)
	
func _corruption_investigation():
	_select_player()
	yield(self, "player_selected")
	player_vars.game.blockedPlayers.append(player_vars.selected_player.playerId)
	player_vars.game_message = player_vars.selected_player.playerName + " fue bloqueado"
	_update_game_in_server(player_vars.game_message)
	
func _mk_ultra():
	_select_player()
	yield(self, "player_selected")
	var player_role = "DEMOCRATA"
	for playerId in player_vars.game.governmentPlayers:
		if playerId == player_vars.selected_player.playerId:
			player_role = "FASCISTA"
	player_vars.game_message = player_vars.selected_player.playerName + " es " + player_role
	_update_game_in_server()
	
func _select_player():
	var _scene = get_tree().change_scene("res://Scenes/SelectPlayer.tscn")
	var selected_player = yield(events, "select_player")
	player_vars.selected_player = selected_player
	
	events.emit_signal("game_updated")
	var _game_scene = get_tree().change_scene("res://Scenes/Game.tscn")
	emit_signal("player_selected")
	
	
func _update_game_in_server(game_message = null):
	player_vars.selected_player = null
	var data = {
		"playerId": player_vars.playerId,
		"roomId": player_vars.roomId,
		"eventType": "game",
		"action": "update",
		"payload": {
			"game": player_vars.game,
			"message": game_message
		}
	}
	message_manager.send(data)
	emit_signal("end_action")
	
func _remove_card(card):
	var data = {
		"playerId": player_vars.playerId,
		"roomId": player_vars.roomId,
		"eventType": "card",
		"action": "endAction",
		"payload": {
			"card": card
		}
	}
	message_manager.send(data)
