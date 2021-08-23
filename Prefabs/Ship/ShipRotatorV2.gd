extends Node2D
class_name ShipRotatorV2

enum RotationState { NO_ADJUSTMENT, MINOR_AJUSTMENT, MAJOR_ADJUSTMENT }

const ANGULAR_VELOCITY_DEAD_ZONE := 0.1
export var dead_zone := 0.2
export var adjustment_zone := 1.0

onready var parent: RigidBody2D = get_parent()
onready var rotate_port: RotationThruster = parent.get_node("RotationPort")
onready var rotate_starboard: RotationThruster = parent.get_node("RotationStarboard")

var _target_angle: float = 0.0
var _target_angle_sign: int = 0
var _thrust_force: float = 0.0
var _adjusted_dead_zone: float = dead_zone
var _rotation_state = RotationState.NO_ADJUSTMENT

func set_rotation_state(new_state: int) -> void:
	if _rotation_state == RotationState.NO_ADJUSTMENT and new_state == RotationState.MINOR_AJUSTMENT:
		_rotation_state = new_state
	elif new_state == RotationState.NO_ADJUSTMENT:
		_rotation_state = new_state
	else:
		_rotation_state = new_state

func _process(_delta: float) -> void:
	_adjusted_dead_zone = _adjust_dead_zone()
	if _thrust_force > 0.0:
		rotate_port.is_emitting = true
		rotate_starboard.is_emitting = false
	elif _thrust_force < 0.0:
		rotate_port.is_emitting = false
		rotate_starboard.is_emitting = true
	else:
		rotate_port.is_emitting = false
		rotate_starboard.is_emitting = false

	set_target_angle(get_local_mouse_position().angle())

	if abs(_target_angle) > _adjusted_dead_zone:
		set_rotation_state(RotationState.MINOR_AJUSTMENT)
	else:
		parent.angular_velocity = lerp(parent.angular_velocity, 0.0, 0.9)
		set_rotation_state(RotationState.NO_ADJUSTMENT)

	_update_debug()

func _physics_process(_delta: float):
	if _rotation_state == RotationState.MINOR_AJUSTMENT:
		_thrust_force = _target_angle_sign
	else:
		_thrust_force = 0.0

func _update_debug() -> void:
	var debug_circle: DebugAngleCircle = $DebugCircle
	debug_circle.dead_zone = _adjusted_dead_zone
	debug_circle.adjustment_zone = adjustment_zone
	debug_circle.target_angle = _target_angle

func set_target_angle(new_angle: float) -> void:
	_target_angle = new_angle
	_target_angle_sign = int(sign(new_angle))

func _adjust_dead_zone() -> float:
	var mouse_dist := get_local_mouse_position().length()
	return dead_zone * clamp(1.0- (mouse_dist / 400.0), 0.2, 1.0)
