extends Node2D

enum State { IDLE, REDRAW }

export var radius := 1.0 setget set_radius
export var dead_zone := 0.2 setget set_dead_zone

var _state: int = State.IDLE
var _dead_zone_lines: Array

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	_state = State.REDRAW

func _process(_delta: float) -> void:
	if not visible:
		_state = State.IDLE
	if _state == State.REDRAW:
		re_draw()
		_state = State.IDLE
		
func re_draw() -> void:
	_redraw_dead_zone_lines()
	_redraw_debug_bg_circle()

func _redraw_dead_zone_lines() -> void:
	var i = -1
	for dz in $Deadzone.get_children():
		if dz is Line2D:
			dz.clear_points()
			dz.add_point(Vector2.ZERO)
			dz.add_point(Vector2.RIGHT.rotated(dead_zone * i) * radius)
			i *= -1
		if dz is Label:
			print(dz)
		

func set_radius(value: float) -> void:
	radius = value
	_state = State.REDRAW
	
func set_dead_zone(value: float) -> void:
	dead_zone = value
	_state = State.REDRAW

func _redraw_debug_bg_circle() -> void:
	var edge = $Edge
	var fill = $Fill
	fill.polygons.clear()
	var points = PoolVector2Array()
	edge.clear_points()
	for i in range(360):
		if i % 4 != 0:
			continue
		var point = Vector2.UP.rotated(deg2rad(i)) * radius
		edge.add_point(point)
		points.append(point)
	fill.set_polygon(points)
	edge.add_point(Vector2.UP.rotated(deg2rad(0.5)) * radius)
