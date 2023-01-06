extends Node2D

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")

onready var president_label = get_node("PresidentName/Label")
onready var voting_label = get_node("VotingDay/Label")

func _ready():
	events.connect("game_updated", self, "_on_update")
		
func _on_update():
	president_label.text = player_vars.president_name()
	voting_label.text = "Elecciones en " + str(player_vars.game.roundsForNextElections) + " día(s)"
