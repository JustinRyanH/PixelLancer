extends Node2D

export var stop_buffer := 0.2
export var rotation_speed := 2.0

onready var rotate_port := $RotationPort
onready var rotate_starboard := $RotationStarboard

onready var parent: RigidBody2D = get_parent()

var rotation_direction = 0

func _process(delta: float) -> void:
	rotate_towards_mouse(delta)
	_handle_thrusters()
		
func _handle_thrusters() -> void:
	if rotation_direction > 0:
		rotate_port.is_emitting = true
		rotate_starboard.is_emitting = false
	elif rotation_direction < 0:
		rotate_port.is_emitting = false
		rotate_starboard.is_emitting = true
	else:
		rotate_starboard.is_emitting = false
		rotate_port.is_emitting = false
	
func rotate_towards_mouse(_delta: float) -> void:
	var mouse_rotation := get_local_mouse_position().angle()
	var target_dist = abs(mouse_rotation / PI)
	
	if target_dist < stop_buffer:
		rotation_direction = 0
		parent.angular_velocity = lerp(parent.angular_velocity, 0, 0.999)
	else:
		rotation_direction = int(sign(mouse_rotation))		
		parent.angular_velocity = sign(mouse_rotation) * rotation_speed

