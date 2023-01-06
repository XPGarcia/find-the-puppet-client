extends Control

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

func _ready():
	events.connect("game_updated", self, "_on_update")

func _on_update():
	if player_vars.status == "VOTING":
		self.visible = true
	else:
		self.visible = false
