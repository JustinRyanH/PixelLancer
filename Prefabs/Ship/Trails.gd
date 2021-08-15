extends Node2D


var linear_velocity := Vector2.ZERO setget set_velocity
onready var edge1 = $Edge
onready var edge2 = $Edge2
onready var edge3 = $Edge3

onready var _initial_color: Color = edge1.modulate
export var debug_color: Color 

func set_velocity(new_velocity: Vector2) -> void:
	linear_velocity = new_velocity
	var e1 = abs(edge1.position.normalized().rotated(global_rotation).x)
	var e2 = abs(edge2.position.normalized().rotated(global_rotation).x)
	var e3 = abs(edge3.position.normalized().rotated(global_rotation).x)
	
	if e1 < e2 and e1 < e3:
		edge1.visible = false
	else:
		edge1.visible = true
	if e2 < e1 and e2 < e3:
		edge2.visible = false
	else:
		edge2.visible = true
	if e3 < e1 and e3 < e2:
		edge3.visible = false
	else:
		edge3.visible = true
