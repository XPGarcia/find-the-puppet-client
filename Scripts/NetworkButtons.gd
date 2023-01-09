extends Control

onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

func _on_JoinButton_pressed():
	if player_vars.name == null or player_vars.roomId == null:
		return

	var data = {
		"eventType": "room",
		"action": "join",
		"payload": {
			"roomId": player_vars.roomId,
			"playerId": player_vars.playerId,
			"playerName": player_vars.playerName,
		}
	}
	message_manager.send(data)


func _on_CreateButton_pressed():
	if player_vars.name == null:
		return
		
	var data = {
		"eventType": "room",
		"action": "create",
		"payload": {
			"playerId": player_vars.playerId,
			"playerName": player_vars.playerName,
		}
	}
	message_manager.send(data)
