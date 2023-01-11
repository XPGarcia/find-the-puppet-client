extends Node

onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

func vote_for_eliminate_player(selectedPlayerId):
	var vote_data = {
		"playerId": player_vars.playerId,
		"roomId": player_vars.roomId,
		"eventType": "voting",
		"action": "collectVoteForEliminateVoting",
		"payload": {
			"playerId": player_vars.playerId,
			"selectedPlayerId": selectedPlayerId
		}
	}
	message_manager.send(vote_data)
