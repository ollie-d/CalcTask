extends Node

var random = RandomNumberGenerator.new()
var state = 0
var buttonDelay = 1
export var websocket_url = "ws://70.95.172.59:8765"
var _client = WebSocketClient.new()

func _ready():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")
	
	# Initiate connection to the given URL
	var err = _client.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
		
	set_process_input(true)

func _process(delta):
	_client.poll()

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)
	
func _connected(proto = ""):
	print("Connected with protocol: ", proto)
	_send_data(Handshakes._get_handshake())
	
func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var data = _client.get_peer(1).get_packet().get_string_from_utf8()
	print("Survey data from server: ", data)

func _send_data(data):
	_client.get_peer(1).put_packet(JSON.print(data).to_utf8())

func _on_Submit_pressed():
	var Q1_ANS = 'None'
	var Q2_ANS = 'None'
	for child in $Q1.get_children():
		if child.pressed:
			Q1_ANS = child.text
	for child in $Q2.get_children():
		if child.pressed:
			Q2_ANS = child.text
	
	_send_data({'sid':GlobalVars.sid + '_survey', 'Q1':Q1_ANS, 'Q2': Q2_ANS})
	
	$Q1.visible = false
	$Q2.visible = false
	$Submit.visible = false
	$Label.visible = true
	
