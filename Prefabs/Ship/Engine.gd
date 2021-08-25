extends Node2D

onready var parent: ThrustedShip = get_parent()

const PI_DIV_8 = PI / 8

export var boost_multiplayer := 4.0
export var thruster_power := 100.0
export var max_speed := 900.0
export var thrust_curve: Curve

var boost := false setget set_boost
var _thrust: Vector2 = Vector2.ZERO

onready var thrusters: Thrusters = $Thrusters

func _process(_delta: float) -> void:
	move_input()

func _physics_process(delta: float) -> void:
	if parent.linear_velocity.length_squared() > max_speed * max_speed:
		parent.linear_velocity = parent.linear_velocity.clamped(max_speed)
	if parent.fuel <= 0:
		return
	if boost:
		reduce_fuel(delta * thruster_power)
		parent.apply_central_impulse(
			Vector2.RIGHT.rotated(parent.rotation) * thruster_power * boost_multiplayer * delta)
	if _thrust.length_squared() > 0:
		var direction_match := _thrust.normalized() - Vector2.RIGHT.rotated(parent.rotation)
		var direction_multiplayer := (4.0 - direction_match.length_squared()) / 4.0
		direction_multiplayer = clamp(direction_multiplayer, 0.5, 1.0)
		parent.fuel -= delta
		reduce_fuel(delta * direction_multiplayer)
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
	boost = Input.is_action_pressed("boost") and parent.fuel > 0
	# Normalize the Thrust so that we don't get the
	# the quake strife bug
	_thrust = _thrust.normalized()
	if parent.fuel > 0:
		_emit_thrusters(_thrust)
	else:
		_emit_thrusters(Vector2.ZERO)

	_thrust = _thrust.rotated(parent.rotation)

## Set Thrust Direction for Thruster Emission
# Thrust direction is relative to the screen, but when we emit we need to
# understand the rotation of the ship to decide which ones to turn on.
# First we rotate the _thrust vector in  the opposite rotation  of the ship rotation
# Then we reverse the thrust so that the thruster direction matches with the thruster
func _emit_thrusters(thrust: Vector2) -> void:
	thrusters.emission_vector = -thrust
	thrusters.boost = boost

func reduce_fuel(amount: float) -> void:
	parent.fuel = max(parent.fuel - amount, 0.0)

func set_boost(v: bool) -> void:
	boost = v
