extends Node

var random = RandomNumberGenerator.new()
var state = 0

func _ready():
	# Set global sid first thing
	var c = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
	var ix = range(36)
	random.randomize()
	randomize()
	ix.shuffle()
	for i in range(12):
		GlobalVars.sid += c[ix[i]]

func _on_Button_pressed():
	if state == 0:
		$Instructions.text = 'You will complete two sections of questions.' + '\r\n \r\n' + 'For each section, you will have 300 seconds to complete as many problems as possible.' + '\r\n\r\n' + 'Your goal is to get the highest score possible!'
		state += 1
	elif state == 1:
		print('A')
	pass # Replace with function body.
