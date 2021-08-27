extends Node2D

onready var parent: ThrustedShip = get_parent()

const PI_DIV_8 = PI / 8

export var boost_multiplayer := 4.0
export var thruster_power := 100.0
export var max_speed := 900.0
export var thrust_curve: Curve

var boost := false setget set_boost
var thrust := Vector2.ZERO setget set_thrust_direction
var _rotated_thrust := Vector2.ZERO

onready var thrusters: Thrusters = $Thrusters

func _process(_delta: float) -> void:
	_emit_thrusters(_rotated_thrust)

func _physics_process(delta: float) -> void:
	if parent.linear_velocity.length_squared() > max_speed * max_speed:
		parent.linear_velocity = parent.linear_velocity.clamped(max_speed)
	if parent.fuel <= 0:
		return
	if boost:
		reduce_fuel(delta * thruster_power)
		parent.apply_central_impulse(
			Vector2.RIGHT.rotated(parent.rotation) * thruster_power * boost_multiplayer * delta)
	if _rotated_thrust.length_squared() > 0:
		var direction_multiplayer = direction_multiplayer()
		parent.fuel -= delta
		reduce_fuel(delta * direction_multiplayer)
		parent.apply_central_impulse(_rotated_thrust * thruster_power * direction_multiplayer * delta)

## Set Thrust Direction for Thruster Emission
# Thrust direction is relative to the screen, but when we emit we need to
# understand the rotation of the ship to decide which ones to turn on.
# First we rotate the _thrust vector in  the opposite rotation  of the ship rotation
# Then we reverse the thrust so that the thruster direction matches with the thruster
func _emit_thrusters(p_thrust: Vector2) -> void:
	thrusters.emission_vector = -p_thrust if parent.fuel > 0 else Vector2.ZERO
	thrusters.boost = boost if parent.fuel > 0 else false

func reduce_fuel(amount: float) -> void:
	parent.fuel = max(parent.fuel - amount, 0.0)

func set_boost(v: bool) -> void:
	boost = v and parent.fuel > 0

func set_thrust_direction(v: Vector2) -> void:
	thrust = v
	_rotated_thrust = v.rotated(parent.rotation)

## Reduces the power of thrust based on direction
func direction_multiplayer() -> float:
	var direction_match := _rotated_thrust - Vector2.RIGHT.rotated(parent.rotation)
	var direction_multiplayer := (4.0 - direction_match.length_squared()) / 4.0
	return clamp(direction_multiplayer, 0.5, 1.0)
