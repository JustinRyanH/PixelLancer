extends Control


onready var start_button := $VBoxContainer/Start


func _ready():
	start_button.grab_focus()


func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")

func _on_Quit_pressed():
	get_tree().quit()
