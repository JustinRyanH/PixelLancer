extends Node2D


var emitting := false setget set_emitting
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _thrusters = get_children() 


# Called when the node enters the scene tree for the first time.
func _ready():
	for thruster in _thrusters:
		thruster.emitting = false

func set_emitting(p_emitting: bool) -> void:
	emitting = p_emitting
	for thruster in _thrusters:
		thruster.emitting = p_emitting
