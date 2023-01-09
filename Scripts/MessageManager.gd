extends Node

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")

func send(message):
	player_vars.websocket_client.get_peer(1).put_packet(JSON.print(message).to_utf8())

func receive(message):
	if message.responseType == "connection":
		player_vars.playerId = message.playerId
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
	return
	
func _update_player_vars(message):
	player_vars.roomId = message.roomId
	player_vars.players = message.clients
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
	player_vars.game = game
	
	if "status" in message:
		player_vars.status = message.status
	elif player_vars.game.playerInTurn == player_vars.playerId:
		player_vars.status = "PLAYING"
	else:
		player_vars.status = "WAITING"
		
	events.emit_signal("game_updated")
	if get_tree().current_scene.name != "Game":
		var _scene = get_tree().change_scene("res://Scenes/Game.tscn")
		
func _handle_deck_message(message):
	var cards = JSON.parse(message.message).result
	player_vars.add_cards(cards)
	events.emit_signal("game_updated")
	
func _handle_voting_message(message):
	if "status" in message:
		player_vars.status = message.status
	elif player_vars.game.playerInTurn == player_vars.playerId:
		player_vars.status = "PLAYING"
	else:
		player_vars.status = "WAITING"
	
	var data = JSON.parse(message.message).result
	if "card" in data:
		player_vars.card_on_board = data.card
		events.emit_signal("put_card_on_board")
	elif "game" in data:
		player_vars.card_on_board = null
		player_vars.game = data.game
		events.emit_signal("game_updated")
		
	events.emit_signal("voting_on_going")
