extends Control
class_name ControlsUI

signal close

func _ready():
	grab_focus()

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("close")
		queue_free()
