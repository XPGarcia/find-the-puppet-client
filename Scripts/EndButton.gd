extends Button

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

func _ready():
	events.connect("game_updated", self, "_on_update")
	events.connect("voting_on_going", self, "_on_update")
		
func _on_update():
	var player_in_turn = player_vars.get_player_in_turn()
	if player_in_turn.playerId == player_vars.playerId and player_vars.status == 'PLAYING' and player_vars.has_played:
		self.visible = true
	else:
		self.visible = false
		
	if player_in_turn.playerId != player_vars.playerId and player_vars.has_played:
		player_vars.has_played = false

func _on_EndButton_pressed():
	player_vars.has_played = false
	player_vars.has_drawn_card = false
	player_vars.card_on_board = null
	var data = {
		"roomId": player_vars.roomId,
		"playerId":  player_vars.playerId,
		"eventType": "game",
		"action": "endTurn",
	}
	message_manager.send(data)
