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
onready var profile_partner_sprite = get_node("Images/Profile/ProfilePartnerImage")

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
	if player_vars.get_role() == "fascista":
		role_sprite.set_texture(facist_sprite)
		_update_partner_sprite()
		facist_win_condition.visible = true
	else:
		role_sprite.set_texture(democrat_sprite)
		democrat_win_condition.visible = true
		
func _update_partner_sprite():
	var partner = _get_fascist_partner()
	if partner == null:
		return
	var partner_profile = load("res://Assets/" + partner.playerProfile)
	profile_partner_sprite.visible = true
	profile_partner_sprite.set_texture(partner_profile)
	
func _get_fascist_partner():
	var partnerId
	for playerId in player_vars.game.governmentPlayers:
		if playerId != player_vars.playerId:
			partnerId = playerId		
	var partner
	for player in player_vars.clients:
		if player.playerId == partnerId:
			partner = player
	return partner	
