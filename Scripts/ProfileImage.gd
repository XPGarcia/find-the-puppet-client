extends Sprite

onready var message_manager = get_node("/root/MessageManager")
onready var player_vars = get_node("/root/PlayerVariables")
onready var voting_event_manager = get_node("/root/VotingEventManager")

var player

func _on_SelectedButton_pressed():
	if player_vars.status == "ELIMINATE_VOTING":
		_eliminate_player_vote()
		
func _eliminate_player_vote():
	voting_event_manager.vote_for_eliminate_player(player.playerId)
		
func set_player(data):
	player = data
