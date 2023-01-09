extends Control

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")

onready var roomId = get_node("Room/RoomId")
onready var hostName = get_node("Host/HostName")

func _ready():
	events.connect("game_updated", self, "_on_update")
	_on_update()
		
func _on_update():
	_update_labels()
	_update_player_position_labels()
	
		
func _update_labels():
	roomId.text = player_vars.roomId
	hostName.text = player_vars.hostName
	
func _update_player_position_labels():
	var position = 1
	for player in player_vars.players:
		var path = "PlayerNames/PlayerName" + str(position)
		var playerName = get_node(path)
		playerName.text = str(position) + ". " + player.playerName
		position = position + 1
