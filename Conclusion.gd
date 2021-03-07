extends Node

var random = RandomNumberGenerator.new()
var state = 0

func _ready():
	preload("res://Survey.tscn")

func _on_Continue_pressed():
	get_tree().change_scene("res://Survey.tscn")

func _on_NoThanks_pressed():
	$Continue.visible = false
	$NoThanks.visible = false
	$Instructions.text = 'Thank you for your time, you may now close the application!'
