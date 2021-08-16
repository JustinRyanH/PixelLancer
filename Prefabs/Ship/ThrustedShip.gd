extends RigidBody2D

const PI_DIV_8 = PI / 8

## TODO: Remove
export var movement_speed_modifier := 1
export var rotation_speed = 1.0
export var stop_buffer := 0.01
var _movement: Vector2 = Vector2.ZERO

onready var look_crosshair: Node2D = $LookCrossHair

func _process(delta: float) -> void:
	rotate_towards_mouse(delta)
	update_crosshairs()
	debug_move(delta)

func rotate_towards_mouse(delta: float) -> void:
	var _mouse_rotation := get_local_mouse_position().angle()
	if abs(_mouse_rotation) > 1.0:
		rotate(_mouse_rotation * rotation_speed * delta)
	elif abs(_mouse_rotation) > stop_buffer:
		rotate(sign(_mouse_rotation) * rotation_speed * delta)

func debug_move(delta: float) -> void:
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

func update_crosshairs() -> void:
	var _mouse_pos = get_local_mouse_position().normalized()
	look_crosshair.position = _mouse_pos * 150.0
	look_crosshair.rotation_degrees = rad2deg(_mouse_pos.angle()) + 90.0
