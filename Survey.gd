extends Node

var random = RandomNumberGenerator.new()
var state = 0
var buttonDelay = 1
export var websocket_url = "ws://70.95.172.59:8765"
var _client = WebSocketClient.new()
var Q1_ANS
var Q2_ANS
var Q3_ANS

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
	$HSlider/yourAnswer/answer.text = str($HSlider.value)
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
	if $Submit.text == 'Next Page':
		Q1_ANS = $HSlider.value
		$Submit.text = 'Submit'
		$Q3.visible = true
		$Q1.text = 'How good do you think you are at mental math?'
		$HSlider/vdiff.text = 'I think I am very' + '\r\n' + 'good at mental math'
		$HSlider/ndiff.text = 'I think I am very' + '\r\n' + 'bad at mental math'
		$HSlider.value = 50
	else:
		Q3_ANS = 'None'
		Q2_ANS = $HSlider.value
		for child in $Q3.get_children():
			if child.pressed:
				Q3_ANS = child.text
		
		_send_data({'sid':GlobalVars.sid + '_survey', 'Q1_diff':Q1_ANS, 'Q2_mental': Q2_ANS, 'Q3': Q3_ANS})
	
		$Q1.visible = false
		$Q3.visible = false
		$HSlider.visible = false
		$Submit.visible = false
		$Label.visible = true
	
