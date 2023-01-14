extends Node

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")

func send(message):
	player_vars.websocket_client.get_peer(1).put_packet(JSON.print(message).to_utf8())

func receive(message):
	if message.responseType == "connection":
		player_vars.playerId = message.playerId
		return
		
	if player_vars.eliminated:
		var _scene = get_tree().change_scene("res://Scenes/Eliminated.tscn")
		return
		
	if "status" in message and (message.status == "FASCISTS_WON" or message.status == "DEMOCRATS_WON"):
		player_vars.status = message.status
		var _scene = get_tree().change_scene("res://Scenes/EndGame.tscn")
		return
	
	_update_player_vars(message)
	
	if message.responseType == "room":
		_handle_room_message(message)
		return
	elif message.responseType == "game":
		_handle_game_message(message)
		return
	elif message.responseType == "deck":
		_handle_deck_message(message)
		return
	elif message.responseType == "voting":
		_handle_voting_message(message)
		return
	elif message.responseType == "card":
		_handle_card_message(message)
		return
	
func _update_player_vars(message):
	player_vars.roomId = message.roomId
	player_vars.clients = message.clients
	if "hostName" in message:
		player_vars.hostName = message.hostName
	if player_vars.playerProfile == null or player_vars.playerProfile == "":
		player_vars.update_profile()
		
func _handle_room_message(message):
	if "status" in message:
		player_vars.status = message.status
	if player_vars.status == "INROOM" and (player_vars.playerProfile == null or player_vars.playerProfile == ""):
		var data = {
			"eventType": "room",
			"action": "updateProfile",
			"payload": {
				"roomId": player_vars.roomId,
				"playerId": player_vars.playerId
			}
		}
		send(data)
	events.emit_signal("game_updated")
	if player_vars.status == "INROOM":
		var _scene = get_tree().change_scene("res://Scenes/Room.tscn")
	
func _handle_game_message(message):
	var game = JSON.parse(message.message).result
	_handle_new_round(game)
	player_vars.game = game
	
	_set_player_status(message)
		
	events.emit_signal("game_updated")
	
	if get_tree().current_scene.name != "Game":
		var _scene = get_tree().change_scene("res://Scenes/Game.tscn")
		
func _handle_deck_message(message):
	var cards = JSON.parse(message.message).result
	player_vars.add_cards(cards)
	events.emit_signal("game_updated")
	
func _handle_voting_message(message):
	_set_player_status(message)
	
	var data = JSON.parse(message.message).result
	if "card" in data:
		player_vars.card_on_board = data.card
		events.emit_signal("put_card_on_board")
	elif "game" in data:
		player_vars.card_on_board = null
		player_vars.game = data.game
		_set_player_status(message)
		events.emit_signal("game_updated")
		
	events.emit_signal("voting_on_going")
	
func _handle_card_message(message):
	var data = JSON.parse(message.message).result
	if "card" in data:
		player_vars.card_on_board = data.card
		events.emit_signal("put_card_on_board")
	else:
		player_vars.card_on_board = null
		print("here")
	
func _set_player_status(message):
	if "status" in message:
		player_vars.status = message.status
	elif player_vars.game.playerInTurn == player_vars.playerId:
		player_vars.status = "PLAYING"
	else:
		player_vars.status = "WAITING"
		
func _handle_new_round(new_game):
	if player_vars.game.size() == 0 or player_vars.game.roundsPlayed == new_game.roundsPlayed:
		return
		
	var data = {
		"playerId": player_vars.playerId,
		"roomId": player_vars.roomId,
		"eventType": "voting",
	}
	# delta difference between 4 => (reset election days) - 1 (before reseting)
	if new_game.roundsForNextElections - player_vars.game.roundsForNextElections == 3:
		data.action = "startPresidentVoting"
		send(data)
	else:
		data.action = "startEliminateVoting"
		send(data)
