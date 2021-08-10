extends Node2D


var emitting := false setget set_emitting
var emitting_engines := false setget set_emitting_engines

onready var engine_thrusters = $MainEngines.get_children()

func _ready():
	for thruster in engine_thrusters:
		thruster.emitting = false

func set_emitting(p_emitting: bool) -> void:
	set_emitting_engines(p_emitting)

func set_emitting_engines(p_emitting: bool) -> void:
	emitting = p_emitting
	for thruster in engine_thrusters:
		thruster.emitting = p_emitting
