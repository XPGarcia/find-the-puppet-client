extends Node2D

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

var initial_x_position = 15
var initial_y_position = 20
var x_padding = 150

func _ready():
	events.connect("game_updated", self, "_on_update")
	var data = {
		"playerId": player_vars.playerId,
		"roomId": player_vars.roomId,
		"eventType": "deck",
		"action": "draw",
		"payload": {
			"quantity": 3
		}
	}
	message_manager.send(data)
		
func _on_update():
	for i in len(player_vars.hand):
		var card = player_vars.hand[i]
		var card_scene = _load_card_scene(card)
		_set_card(card_scene, card)
		_set_card_position(card_scene, i)
		self.add_child(card_scene)

func _load_card_scene(card):
	var scene_name = _map_card_to_scene(card)
	var card_resource = load("res://Scenes/" + scene_name)
	return card_resource.instance()
	
func _map_card_to_scene(card):
	if card.type == "law":
		return "LawCard.tscn"
	if card.quickPlay:
		return "QuickActionCard.tscn"
	return "ActionCard.tscn"
	
func _set_card_position(card_scene, index):
	var x_position = initial_x_position + (x_padding * index) 
	var position = Vector2(x_position, initial_y_position)
	card_scene.set_position(position)
	
func _set_card(card_scene, card):
	if card.type == "law":
		_set_law_card(card_scene, card)
	else:
		_set_action_card(card_scene, card)
		
func _set_law_card(card_scene, card):
	var description = card_scene.get_node("Description")
	description.text = card.body

func _set_action_card(card_scene, card):
	var title = card_scene.get_node("Title")
	var description = card_scene.get_node("Description")
	title.text = card.title
	description.text = card.body
