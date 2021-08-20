extends Node2D
class_name RotationThruster

export var is_emitting := false setget set_emitting
onready var children = get_children()

func set_emitting(p_emitting) -> void:
	is_emitting = p_emitting
	for child in children:
		child.emitting = p_emitting
