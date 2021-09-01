extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("game_pause"):
		_pause_game()

func _pause_game() -> void:
	var tree = get_tree()
	var current_state = tree.paused
	
	if current_state == true:
		visible = false
	else:
		visible = true
		
	tree.paused = !current_state


func _on_Return_pressed():
	_pause_game()

func _on_Exit_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
