tool
class_name CircleFillTool, "res://Icons/circle_fill.svg"
extends Polygon2D


export var radius := 1.0 setget set_radius
export var segments := 90 setget set_segments

func _ready():
	_redraw()

func _redraw() -> void:
	polygons.clear()
	var points = PoolVector2Array()
	var v = 360 / segments
	for i in range(360):
		if i % v != 0:
			continue
		var point = Vector2.UP.rotated(deg2rad(i)) * radius
		points.append(point)
	set_polygon(points)

func set_radius(v: float) -> void:
	radius = v
	_redraw()
	
func set_segments(v: int) -> void:
	segments = int(clamp(abs(v), 20, 360))
	_redraw()
