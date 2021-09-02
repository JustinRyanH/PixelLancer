extends Node


func _ready():
	_unpaused_mouse()
	Events.connect("game_paused", self, "_game_paused")
	Events.connect("game_unpaused", self, "_game_unpaused")


func _game_paused() -> void:
	var tree = get_tree()
	tree.paused = true
	_paused_mouse()
	
func _game_unpaused() -> void:
	var tree = get_tree()
	tree.paused = false
	_unpaused_mouse()


func _unpaused_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
func _paused_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
