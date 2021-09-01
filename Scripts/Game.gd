extends Node


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Events.connect("game_paused", self, "_game_paused")
	Events.connect("game_unpaused", self, "_game_unpaused")


func _game_paused() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var tree = get_tree()
	tree.paused = true
	
func _game_unpaused() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var tree = get_tree()
	tree.paused = false
