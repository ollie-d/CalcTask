extends Node

func _ready():
	preload("res://Introduction.tscn")

func _on_Button_pressed():
		get_tree().change_scene("res://Introduction.tscn")
