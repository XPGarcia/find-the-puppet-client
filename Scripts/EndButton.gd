extends Button

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

func _ready():
	events.connect("game_updated", self, "_on_update")	
		
func _on_update():
	var player_in_turn = player_vars.get_player_in_turn()
	if player_in_turn.playerId == player_vars.playerId:
		self.visible = true
	else:
		self.visible = false

func _on_EndButton_pressed():
	var data = {
		"roomId": player_vars.roomId,
		"playerId":  player_vars.playerId,
		"eventType": "game",
		"action": "endTurn",
	}
	message_manager.send(data)
