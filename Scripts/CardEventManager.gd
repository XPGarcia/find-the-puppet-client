extends Node

onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

func activate_card(card):
	player_vars.has_played = true 
	player_vars.card_on_board = card
	if card.type == "law":
		_start_law_voting(card)

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
