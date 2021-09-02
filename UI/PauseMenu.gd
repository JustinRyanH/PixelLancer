extends Control

signal pause
var is_control_open := false

const CONTROL_UI = preload("res://UI/ControlsUI.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not is_control_open:
			_unpause_game() if get_tree().paused else _pause_game()

func _pause_game() -> void:
	Events.emit_signal("game_paused")
	
	visible = true
	$VBoxContainer/Return.grab_focus()

func _unpause_game() -> void:
	Events.emit_signal("game_unpaused")
	visible = false

func _on_Return_pressed():
	_unpause_game()

func _on_Exit_pressed():
	_unpause_game()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_Controls_pressed():
	is_control_open = true
	var options: ControlsUI = CONTROL_UI.instance()
	options.connect("close", self, "_on_control_closed")
	add_child(options)
	
func _on_control_closed():
	yield(get_tree().create_timer(0.05), "timeout")
	is_control_open = false
