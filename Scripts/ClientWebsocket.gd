extends Node

var websocket_url = "wss://34.201.249.229"
#var websocket_url = "ws://localhost:3000"

var _client = WebSocketClient.new()

onready var player_vars = get_node("/root/PlayerVariables")
onready var message_manager = get_node("/root/MessageManager")

func _ready():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")

	_client.connect("data_received", self, "_on_data")

	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	player_vars.websocket_client = _client
	

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected():
	_client.get_peer(1).put_packet("{}".to_utf8())

func _on_data():
	var message = _client.get_peer(1).get_packet().get_string_from_utf8()
	var json_result = JSON.parse(message)
	if json_result.error == OK:
		message_manager.receive(json_result.result)

func _process(_delta):
	_client.poll()
