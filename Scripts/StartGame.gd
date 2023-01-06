extends Button


onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

func _pressed() -> void:
	var data = {
		"id": player_vars.id,
		"eventType": "game",
		"action": "start"
	}
	message_manager.send(data)
