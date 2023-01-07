extends Node2D

onready var events = get_node("/root/Events")
onready var card_event_manager = get_node("/root/CardEventManager")
onready var player_vars = get_node("/root/PlayerVariables")

onready var drop_zone = get_node("/root/Game/RightSide/Board/DropZone")

var card
var in_board = false
var selected = false
var initial_position
var rest_point

func _ready():
	initial_position = global_position
	
func set_card(new_card):
	card = new_card

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true

func _physics_process(delta):
	if in_board:
		return
	
	if selected and player_vars.status == "PLAYING" and !player_vars.has_played:
		global_position = lerp(global_position, get_global_mouse_position(), 50 * delta)
	elif !selected and in_board:
		global_position = lerp(global_position, rest_point, 10 * delta)
	else:
		global_position = lerp(global_position, initial_position, 10 * delta)
		
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
			var distance = global_position.distance_to(drop_zone.global_position)
			if distance < 150:
				rest_point = drop_zone.global_position
				in_board = true
				_play_card()
			else:
				in_board = false

func _play_card():
	player_vars.remove_card(card)
	player_vars.card_on_board = card
	events.emit_signal("put_card_on_board")
	card_event_manager.activate_card(card)
	self.queue_free()
