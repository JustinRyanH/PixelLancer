extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_pause"):
		_unpause_game() if get_tree().paused else _pause_game()

func _pause_game() -> void:
	var tree = get_tree()
	visible = true
	tree.paused = true

func _unpause_game() -> void:
	var tree = get_tree()
	visible = false
	tree.paused = false

func _on_Return_pressed():
	_unpause_game()

func _on_Exit_pressed():
	_unpause_game()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
