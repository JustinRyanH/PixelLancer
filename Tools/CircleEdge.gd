tool
extends Line2D

export var radius := 1.0 setget set_radius

# Called when the node enters the scene tree for the first time.
func _ready():
	_redraw()

func _redraw() -> void:
	_scratch()
	pass

func set_radius(v: float) -> void:
	radius = v
	_redraw()

func _scratch() -> void:
	clear_points()
	for i in range(360):
		if i % 4 != 0:
			continue
		var point = Vector2.UP.rotated(deg2rad(i)) * radius
		add_point(point)
	add_point(Vector2.UP.rotated(deg2rad(0.5)) * radius)
