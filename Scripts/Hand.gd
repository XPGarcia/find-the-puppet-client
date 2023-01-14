extends Node2D

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

var initial_x_position = 80
var initial_y_position = 100
var x_padding = 100

func _ready():
	events.connect("game_updated", self, "_on_update")
	if len(player_vars.hand) == 0:
		_draw_card(3)
		
func _on_update():
	if player_vars.get_player_in_turn().playerId == player_vars.playerId and !player_vars.has_drawn_card:
		_draw_card(1)
		player_vars.has_drawn_card = true
	
	_clear_hand()
	for i in len(player_vars.hand):
		var card = player_vars.hand[i]
		var card_scene = _load_card_scene(card)
		_set_card(card_scene, card)
		_set_card_position(card_scene, i)
		card_scene.set_card(card)
		self.add_child(card_scene)
		
func _clear_hand():
	for card_node in self.get_children():
		self.remove_child(card_node)
		card_node.queue_free()
		
func _draw_card(quantity):
	var data = {
		"playerId": player_vars.playerId,
		"roomId": player_vars.roomId,
		"eventType": "deck",
		"action": "draw",
		"payload": {
			"quantity": quantity
		}
	}
	message_manager.send(data)
	

func _load_card_scene(card):
	var scene_name = _map_card_to_scene(card)
	var card_resource = load("res://Scenes/" + scene_name)
	return card_resource.instance()
	
func _map_card_to_scene(card):
	if card.type == "law":
		return "LawCard.tscn"
	if card.quickPlay:
		print(card)
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
