extends Control

onready var start_button := $VBoxContainer/Start

const CONTROLS_UI = preload("res://UI/ControlsUI.tscn")

func _ready():
	start_button.grab_focus()

func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Controls_pressed():
	var options = CONTROLS_UI.instance()
	get_tree().root.add_child(options)
