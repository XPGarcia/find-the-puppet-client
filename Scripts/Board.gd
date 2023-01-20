extends Node2D

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

onready var round_label = get_node("RoundLabel")
onready var drop_zone = get_node("DropZone")
onready var game_message_label = get_node("GameMessage")

var card_scene

func _ready():
	events.connect("game_updated", self, "_on_update")
	events.connect("put_card_on_board", self, "_on_card_placed")
	events.connect("set_game_message", self, "_set_game_message_label")

func _on_update():
	_set_game_message_label()
	
	_on_card_placed()
	round_label.text = "Día " + str(player_vars.game.roundsPlayed + 1)
	
func _on_card_placed():
	_remove_card_from_board()
	if player_vars.card_on_board != null:
		_place_card_on_board()
#	if player_vars.card_on_board != null:
#		_place_card_on_board()
#	else:
#		_remove_card_from_board()
		
func _set_game_message_label():
	if player_vars.game_message != null:
		game_message_label.text = player_vars.game_message
	else:
		game_message_label.text = ""

func _place_card_on_board():
	if card_scene == null:
		var card = player_vars.card_on_board
		card_scene = _load_card_scene(player_vars.card_on_board)
		_set_card(card_scene, card)
		card_scene.set_card(card)
		card_scene.set_script(null)
		drop_zone.add_child(card_scene)
	
func _remove_card_from_board():
	if player_vars.card_on_board == null and card_scene != null:
		drop_zone.remove_child(card_scene)
		card_scene = null

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
