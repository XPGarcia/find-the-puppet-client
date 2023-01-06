extends Node2D

onready var events = get_node("/root/Events")
onready var player_vars = get_node("/root/PlayerVariables")

onready var democrat_win_condition = get_node("DemocratWinCondition")
onready var facist_win_condition = get_node("FacistWinCondition")

var democrat_sprite = preload("res://Assets/Democratic.png")
var facist_sprite = preload("res://Assets/Facist.png")

onready var role_label = get_node("RoleLabel")
onready var role_sprite = get_node("Images/Role/RoleImage")
onready var profile_sprite = get_node("Images/Profile/ProfileImage")

func _ready():
	events.connect("game_updated", self, "_on_update")
		
func _on_update():
	_update_role_text()
	_update_player_sprite()
	_update_role_sprite_and_win_condition()
		
func _update_role_text():
	role_label.text = player_vars.playerName + " eres " + player_vars.get_role()
	
func _update_player_sprite():
	var sprite = load("res://Assets/" + player_vars.playerProfile)
	profile_sprite.set_texture(sprite)
	
func _update_role_sprite_and_win_condition():
	if player_vars.get_role() == "facista":
		role_sprite.set_texture(facist_sprite)
		facist_win_condition.visible = true
	else:
		role_sprite.set_texture(democrat_sprite)
		democrat_win_condition.visible = true
