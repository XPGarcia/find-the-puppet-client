extends Sprite

onready var events = get_node("/root/Events")
onready var message_manager = get_node("/root/MessageManager")
onready var player_vars = get_node("/root/PlayerVariables")
onready var voting_event_manager = get_node("/root/VotingEventManager")

var player

func _on_SelectedButton_pressed():
	if player_vars.status == "ELIMINATE_VOTING":
		_eliminate_player_vote()
	elif player_vars.status == "PRESIDENT_VOTING":
		_president_player_vote()
	else:
		events.emit_signal("select_player", player.playerId)
#		if get_tree().current_scene.name != "Game":
#			var _scene = get_tree().change_scene("res://Scenes/Game.tscn")
		
func _eliminate_player_vote():
	voting_event_manager.vote_for_eliminate_player(player.playerId)
	
func _president_player_vote():
	voting_event_manager.vote_for_president_player(player.playerId)
		
func set_player(data):
	player = data
