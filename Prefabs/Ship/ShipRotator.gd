extends Node2D
class_name ShipRotator


enum RotationDirection { NONE, CLOCKWISE = 1, CCLOCKWISE = -1 }
enum States { NO_ROTATION, ADJUSTMENT, MAJOR_ROTATION }

const ANGULAR_VELOCITY_DEAD_ZONE := 0.1
export var dead_zone := 0.2
export var adjustment_zone := 1.0
export var rotation_speed := 75.0
var rotation_dir: int = RotationDirection.NONE setget set_rotation_dir

onready var parent: RigidBody2D = get_parent()
onready var rotate_port: RotationThruster = parent.get_node("RotationPort")
onready var rotate_starboard: RotationThruster = parent.get_node("RotationStarboard")

var _target_angle: float = 0.0
var _target_angle_sign: int = 0
var _adjusted_dead_zone: float = dead_zone

var state: int = States.NO_ROTATION

func set_rotation_dir(dir: int) -> void:
	rotation_dir = dir
	match dir:
		RotationDirection.NONE:
			rotate_port.is_emitting = false
			rotate_starboard.is_emitting = false
		RotationDirection.CCLOCKWISE:
			rotate_port.is_emitting = false
			rotate_starboard.is_emitting = true
		RotationDirection.CLOCKWISE:
			rotate_port.is_emitting = true
			rotate_starboard.is_emitting = false

func _ready():
	var debug_circle := $DebugCircle
	debug_circle.dead_zone = dead_zone
	debug_circle.adjustment_zone = adjustment_zone


func _process(_delta: float) -> void:
	set_target_angle(get_local_mouse_position().angle())
	_adjusted_dead_zone = _adjust_dead_zone(get_local_mouse_position().length())
	rotate_towards_mouse()

	_update_debug()

func _update_debug() -> void:
	var debug_circle := $DebugCircle
	debug_circle.dead_zone = _adjusted_dead_zone

func _thrust(direction: int, percentage: float) -> void:
	set_rotation_dir(direction)
	parent.apply_torque_impulse(direction * rotation_speed * percentage)

func rotate_towards_mouse() -> void:
	var abs_mouse_rotation := abs(_target_angle)
	if abs_mouse_rotation < _adjusted_dead_zone:
		if abs(parent.angular_velocity) > ANGULAR_VELOCITY_DEAD_ZONE:
			set_rotation_dir(-int(sign(parent.angular_velocity)))
		else:
			set_rotation_dir(0)
	elif abs_mouse_rotation < adjustment_zone:
		if abs(parent.angular_velocity) > 1.25:
			_thrust(-1 * _target_angle_sign, 1.0)
		else:
			var counter_force = clamp(parent.angular_velocity, 0.2, 1.0)
			_thrust(_target_angle_sign, counter_force)
	else:
		_thrust(_target_angle_sign, 1.0)

func _adjust_dead_zone(mouse_dist: float) -> float:
		return dead_zone * clamp(1.0- (mouse_dist / 400.0), 0.33, 1.0)

func set_target_angle(new_angle: float) -> void:
	_target_angle = new_angle
	_target_angle_sign = int(sign(new_angle))
