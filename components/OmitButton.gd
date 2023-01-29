extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_OmitButton_pressed():
	var vote_data = {
		"playerId": player_vars.playerId,
		"roomId": player_vars.roomId,
		"eventType": "voting",
		"payload": {
			"playerId": player_vars.playerId,
		}
	}
	print(vote_data)
	if player_vars.status == "ELIMINATE_VOTING":
		vote_data.action = "collectVoteForEliminateVoting"
	elif player_vars.status == "PRESIDENT_VOTING":
		vote_data.action = "collectVoteForPresidentVoting"
	message_manager.send(vote_data)
