tool
class_name CircleEdgeTool, "res://Icons/circle_outline.svg"
extends Line2D

export var radius := 1.0 setget set_radius
export var segments := 90 setget set_segments

# Called when the node enters the scene tree for the first time.
func _ready():
	_redraw()

func _redraw() -> void:
	clear_points()
	var v = 360 / segments
	for i in range(360):
		if i % v != 0:
			continue
		var point = Vector2.UP.rotated(deg2rad(i)) * radius
		add_point(point)
	add_point(Vector2.UP.rotated(deg2rad(0.5)) * radius)

func set_radius(v: float) -> void:
	radius = v
	_redraw()
	
func set_segments(v: int) -> void:
	segments = clamp(abs(v), 20, 360)
	_redraw()
