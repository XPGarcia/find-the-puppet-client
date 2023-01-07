extends Node2D

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

var vote_data

func _ready():
	events.connect("game_updated", self, "_on_update")
	events.connect("voting_on_going", self, "_on_update")

func _on_update():
	vote_data = {
		"playerId": player_vars.playerId,
		"roomId": player_vars.roomId,
		"eventType": "voting",
		"action": "",
		"payload": {}
	}
	if player_vars.status == "VOTING":
		self.visible = true
	else:
		self.visible = false


func _on_YesButton_pressed():
	vote_data.payload.vote = "YES"
	if player_vars.is_law_election():
		vote_data.action = "collectVoteForLawVoting"
		vote_data.payload.card = player_vars.card_on_board
	message_manager.send(vote_data)


func _on_NoButton_pressed():
	vote_data.payload.vote = "NO"
	if player_vars.is_law_election():
		vote_data.action = "collectVoteForLawVoting"
		vote_data.payload.card = player_vars.card_on_board
	message_manager.send(vote_data)
