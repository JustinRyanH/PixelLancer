extends Node2D

export var movement_speed_modifier := 1
var _movement: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	_movement = Vector2.ZERO
	if Input.is_action_pressed("ui_down"):
		_movement.y += 1
	if Input.is_action_pressed("ui_up"):
		_movement.y -= 1
	if Input.is_action_pressed("ui_right"):
		_movement.x += 1
	if Input.is_action_pressed("ui_left"):
		_movement.x -= 1
	position += _movement * delta * movement_speed_modifier
