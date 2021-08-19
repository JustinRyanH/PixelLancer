extends Node2D
class_name Thrusters

# What is the threadshold for vector to be facing so the Thruster engages
export var threshold := 0.25
var emission_vector := Vector2.ZERO setget set_emission_vector
var boost := false setget set_boost
onready var port_thruster: Particles2D = $PortThruster
onready var starboard_thruster: Particles2D = $StarboardThruster
onready var decel_thruster: Particles2D = $DecelThruster
onready var main_thruster: Particles2D = $MainThruster
onready var trail: Trail = $Trail

func _process(_delta: float) -> void:
	_turn_on_thrusters()

## Engages the Thrusters
# This is likely the simplist form of doing thing. We have a threashold
# since we are realy fully aligned on the ship rotation axis. Ideally we'd
# want to do something with normalizing the Thrusters local position and
# then doing a check of how well that matches sup, and see if that meets
# the threadshold for that setup. However, that is not needed until we
# have more than 4 thrusters
func _turn_on_thrusters() -> void:
	if emission_vector.x < -threshold:
		main_thruster.emitting = true
	elif boost:
		main_thruster.emitting = true
	else:
		main_thruster.emitting  = false
	if emission_vector.x > threshold:
		decel_thruster.emitting = true
	else:
		decel_thruster.emitting  = false
	if emission_vector.y < -threshold:
		port_thruster.emitting = true
	else:
		port_thruster.emitting  = false
	if emission_vector.y > threshold:
		starboard_thruster.emitting = true
	else:
		starboard_thruster.emitting  = false

func set_emission_vector(vec: Vector2) -> void:
	emission_vector = vec

func set_boost(p_boost: bool) -> void:
	boost = p_boost
	trail.is_emitting = boost
