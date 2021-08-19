extends Node2D

onready var parent: RigidBody2D = get_parent()

const PI_DIV_8 = PI / 8

export var thruster_power := 100.0
export var max_speed := 900.0
export var thrust_curve: Curve

var _boost: bool = false
var _thrust: Vector2 = Vector2.ZERO
onready var _target_rotation := rotation
onready var _time_til_target_rotation := 0.0

onready var thrusters: Thrusters = $Thrusters

func _process(_delta: float) -> void:
	move_input()

func _physics_process(delta: float) -> void:
	if parent.linear_velocity.length_squared() > max_speed * max_speed:
		parent.linear_velocity = parent.linear_velocity.clamped(max_speed)

	if _boost:
		parent.apply_central_impulse(
			Vector2.RIGHT.rotated(parent.rotation) * (max_speed * 0.5) * delta)

	if _thrust.length_squared() > 0:
		var direction_match := _thrust.normalized() - Vector2.RIGHT.rotated(rotation)
		var direction_multiplayer := (4.0 - direction_match.length_squared()) / 4.0
		direction_multiplayer = clamp(direction_multiplayer, 0.5, 1.0)
		parent.apply_central_impulse(_thrust * thruster_power * direction_multiplayer * delta)

func move_input() -> void:
	_thrust = Vector2.ZERO
	if Input.is_action_pressed("thrust_up"):
		_thrust.x += 1
	if Input.is_action_pressed("thrust_down"):
		_thrust.x -= 1
	if Input.is_action_pressed("thrust_left"):
		_thrust.y -= 1
	if Input.is_action_pressed("thrust_right"):
		_thrust.y += 1
	_boost = Input.is_action_pressed("boost")
	# Normalize the Thrust so that we don't get the
	# the quake strife bug
	_thrust = _thrust.normalized()
	_emit_thrusters(_thrust)
	_thrust = _thrust.rotated(rotation)

## Set Thrust Direction for Thruster Emission
# Thrust direction is relative to the screen, but when we emit we need to
# understand the rotation of the ship to decide which ones to turn on.
# First we rotate the _thrust vector in  the opposite rotation  of the ship rotation
# Then we reverse the thrust so that the thruster direction matches with the thruster
func _emit_thrusters(thrust: Vector2) -> void:
	thrusters.emission_vector = -thrust
	thrusters.boost = _boost
