extends Node

var websocket_client

var roomId
var hostName
var clients = []

var playerId
var playerName
var playerProfile

var game = {}
var status

var hand = []
var card_on_board
var selected_player_id
var has_drawn_card = false
var has_played = false
var eliminated = false

func add_cards(cards):
	var newHand = []
	for card in hand:
		newHand.append(card)
	for card in cards:
		newHand.append(card)
	hand = newHand
	
func remove_card(card):
	var newHand = []
	for cardInHand in hand:
		if card.id != cardInHand.id:
			newHand.append(cardInHand)
	hand = newHand

func is_host():
	return hostName == playerName
	
func president_name():
	var president
	for player in game.players:
		if player.playerId == game.playerAsPresident:
			president = player
	if president != null:
		return president.playerName
	return ""
	
func get_role():
	var role = "demócrata"
	for id in game.governmentPlayers:
		if id == playerId:
			role = "fascista"
	return role
	
func update_profile():
	for player in clients:
		if player.playerId == playerId:
			playerProfile = player.playerProfile
			
func get_player_in_turn_index():
	var index
	for i in len(game.players):
		if game.players[i].playerId == game.playerInTurn:
			index = i
	return index
	
func get_player_in_turn():
	var index = get_player_in_turn_index()
	return game.players[index]
	
func get_player_by_id(playerId):
	var searchedPlayer
	for player in clients:
		if player.playerId == playerId:
			searchedPlayer = player
	return searchedPlayer
	
func is_law_election():
	return card_on_board != null and card_on_board.type == "law"
	
func reset():
	roomId = null
	hostName = null
	playerName = null
	playerProfile = null
	clients = []
	status = null
	game = {}
	hand = []
	card_on_board = null
	has_drawn_card = false
	has_played = false
	eliminated = false
