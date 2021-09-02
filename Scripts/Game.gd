extends Node


func _ready():
	_hide_mouse()
	Events.connect("game_paused", self, "_game_paused")
	Events.connect("game_unpaused", self, "_game_unpaused")


func _game_paused() -> void:
	var tree = get_tree()
	tree.paused = true
	_unhide_mouse()
	
func _game_unpaused() -> void:
	var tree = get_tree()
	tree.paused = false
	_hide_mouse()


func _hide_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _unhide_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
