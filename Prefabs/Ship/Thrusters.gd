extends Node2D


var emitting := false setget set_emitting
var emitting_engines := false setget set_emitting_engines

onready var engine_thrusters = $MainEngines.get_children()

func _ready():
	for thruster in engine_thrusters:
		thruster.emitting = false

func _process(_delta: float) -> void:
	var dir_2d := -Vector2.UP.rotated(get_parent().rotation)
	var dir_3d := Vector3(dir_2d.x, dir_2d.y, 0.0)
	for thruster in engine_thrusters:
		thruster.global_rotation = 0
		thruster.process_material.direction = dir_3d

func set_emitting(p_emitting: bool) -> void:
	set_emitting_engines(p_emitting)

func set_emitting_engines(p_emitting: bool) -> void:
	emitting = p_emitting
	for thruster in engine_thrusters:
		thruster.emitting = p_emitting
