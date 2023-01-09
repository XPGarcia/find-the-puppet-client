extends Label

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")

var card_scene

func _ready():
	events.connect("game_updated", self, "_on_update")
	events.connect("put_card_on_board", self, "_on_update")

func _on_update():
	var player_in_turn = player_vars.get_player_in_turn()
	if player_vars.status == "VOTING":
		self.text = player_in_turn.playerName + " propuso una nueva ley"
	else:	
		self.text = player_in_turn.playerName + " está jugando"
