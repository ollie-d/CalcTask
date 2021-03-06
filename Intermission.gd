extends Node

var random = RandomNumberGenerator.new()
var state = 0
var buttonDelay = 4

func _ready():
	# Set global sid first thing
	$Button.visible = false
	$buttonTimer.start(buttonDelay)
	preload("res://MainTask.tscn")

func _on_Button_pressed():
	$Button.visible = false;
	$buttonTimer.start(buttonDelay)
	get_tree().change_scene("res://MainTask.tscn")

func _on_buttonTimer_timeout():
	$Button.visible = true
