extends Button

onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

func _on_LeaveButton_pressed():
	var data = {
		"eventType": "room",
		"action": "leave",
		"payload": {
			"roomId": player_vars.roomId,
			"playerId": player_vars.playerId,
		}
	}
	player_vars.reset()
	message_manager.send(data)
	var _scene = get_tree().change_scene("res://Scenes/StartMenu.tscn")
