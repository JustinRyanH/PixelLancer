extends Node2D
class_name ShipRotatorV2

const OVERSHOOT_ZONE: float = PI / 2


const ANGULAR_VELOCITY_DEAD_ZONE := 0.1
export var dead_zone := 0.2
export var adjustment_zone := 1.0
export var rotation_multiplayer := 1.0
export var max_angular_velocity := 2.0

onready var parent: RigidBody2D = get_parent()
onready var rotate_port: RotationThruster = parent.get_node("RotationPort")
onready var rotate_starboard: RotationThruster = parent.get_node("RotationStarboard")


var _target_angle: float = 0.0
var _target_angle_sign: int = 0
var _thrust_force: float = 0.0
var _adjusted_dead_zone: float = dead_zone


func emit_thrust() ->  void:
	if _thrust_force > 0.0:
		rotate_port.is_emitting = true
		rotate_starboard.is_emitting = false
	elif _thrust_force < 0.0:
		rotate_port.is_emitting = false
		rotate_starboard.is_emitting = true
	else:
		rotate_port.is_emitting = false
		rotate_starboard.is_emitting = false

func _process(_delta: float) -> void:
	_adjusted_dead_zone = _adjust_dead_zone()
	emit_thrust()

	set_target_angle(get_local_mouse_position().angle())

	if abs(_target_angle) > _speed_adj_zone():
		_thrust_force = _target_angle_sign * rotation_multiplayer
	elif abs(_target_angle) > _adjusted_dead_zone:
		if  _target_angle_sign != sign(parent.angular_velocity):
			print("Overshoot")
		if sign(parent.angular_velocity) == _target_angle_sign:
			_thrust_force = -_target_angle_sign * 0.5 * rotation_multiplayer
		else:
			_thrust_force = _target_angle_sign * rotation_multiplayer
	else:
		if abs(parent.angular_velocity) < 0.5 and abs(parent.angular_velocity) > 0.0:
			parent.angular_velocity = lerp(parent.angular_velocity, 0.0, 0.5)
		_thrust_force = 0

	_update_debug()

func _physics_process(delta: float):
	parent.angular_velocity = clamp(
		parent.angular_velocity + _thrust_force * delta,
		-max_angular_velocity,
		max_angular_velocity
	)

func _update_debug() -> void:
	var debug_circle: DebugAngleCircle = $DebugCircle
	debug_circle.dead_zone = _adjusted_dead_zone
	debug_circle.adjustment_zone = _speed_adj_zone()
	debug_circle.target_angle = _target_angle
	debug_circle.overshoot_zone = OVERSHOOT_ZONE

func _speed_adj_zone() -> float:
	var zone = adjustment_zone * (abs(parent.angular_velocity) / max_angular_velocity)
	return max(zone, _adjusted_dead_zone)

func set_target_angle(new_angle: float) -> void:
	_target_angle = new_angle
	_target_angle_sign = int(sign(new_angle))

func _adjust_dead_zone() -> float:
	var mouse_dist := get_local_mouse_position().length()
	return dead_zone * clamp(1.0- (mouse_dist / 400.0), 0.2, 1.0)
