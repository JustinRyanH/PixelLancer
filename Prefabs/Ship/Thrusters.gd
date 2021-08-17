extends Node2D
class_name Thrusters

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var emission_vector := Vector2.ZERO setget set_emission_vector
onready var port_thruster: Particles2D = $PortThruster
onready var starboard_thruster: Particles2D = $StarboardThruster
onready var decel_thruster: Particles2D = $DecelThruster
onready var main_thruster: Particles2D = $MainThruster

func _process(_delta: float) -> void:
	if emission_vector.length_squared() > 0:
		port_thruster.emitting = true
		starboard_thruster.emitting = true
		decel_thruster.emitting = true
		main_thruster.emitting = true
	else:
		port_thruster.emitting = false
		starboard_thruster.emitting = false
		decel_thruster.emitting = false
		main_thruster.emitting = false

func set_emission_vector(vec: Vector2) -> void:
	emission_vector = vec
