extends Node2D

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")

onready var laws_container = get_node("LawsContainer")

func _ready():
	events.connect("game_updated", self, "_on_update")
	
func _on_update():
	var item = 1
	for law in player_vars.game.approvedLaws:
		var law_scene_container = laws_container.get_node("Law" + str(item))
		var law_scene = _load_law_scene()
		law_scene_container.add_child(law_scene)
		item = item + 1
		
func _load_law_scene():
	var law_resource = load("res://Scenes/ApprovedLaw.tscn")
	return law_resource.instance()
