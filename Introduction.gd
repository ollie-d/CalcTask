extends Node

var random = RandomNumberGenerator.new()
var state = 0
var buttonDelay = 4

func _ready():
	# Set global sid first thing
	$Button.visible = false
	var c = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
	var ix = range(36)
	random.randomize()
	randomize()
	ix.shuffle()
	$buttonTimer.start(buttonDelay)
	for i in range(12):
		GlobalVars.sid += c[ix[i]]
	# Preload next level
	preload("res://BaselineTask.tscn")

func _on_Button_pressed():
	$Button.visible = false;
	$buttonTimer.start(buttonDelay)
	state += 1
	if state == 1:
		$Instructions.text = 'Every time you solve a problem correctly, you will receive 1 point.' + '\r\n \r\n' + 'Every time you solve a problem incorrectly, you will lose 1 point.' + '\r\n \r\n' + 'Once you are ready to submit your response, either press the Submit button or press the Enter/Return key on your keyboard.'
	elif state == 2:
		$Instructions.text =  'There are two sections to this game. You will now play the first one.'+ '\r\n \r\n' + 'Once you are ready to begin playing, click the Play button. Good luck!'
		$Button.text = 'Play'
	elif state == 3:
		get_tree().change_scene("res://BaselineTask.tscn")

func _on_buttonTimer_timeout():
	$Button.visible = true
