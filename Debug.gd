extends Node

export var is_debug: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_debug"):
		Debug.is_debug = !Debug.is_debug
