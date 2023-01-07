extends Control

onready var player_vars = get_node("/root/PlayerVariables")

func _ready():
	player_vars.reset()
