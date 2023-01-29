extends Control

onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

func _ready():
	if !player_vars.is_host():
		self.hide()

func _on_BeginButton_pressed():
#	if len(player_vars.clients) != 5:
#		return
	
	var data = {
		"roomId": player_vars.roomId,
		"playerId": player_vars.playerId,
		"eventType": "game",
		"action": "start"
	}
	message_manager.send(data)
