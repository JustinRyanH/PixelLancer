tool
extends Node2D
class_name DebugAngleCircle

export var radius := 1.0 setget set_radius
export var dead_zone := 0.2 setget set_dead_zone
export var adjustment_zone := 0.4 setget set_adjustment_zone
export var target_angle := 0.0 setget set_target_angle
onready var dead_zone_node := $Deadzone
onready var adjustment_zone_node := $AdjustmentZone
onready var target_angle_node := $TargetAngle
onready var fill_node := $Fill
onready var edge_node := $Edge

func set_radius(v: float) -> void:
	radius = v
	_redraw()

func set_dead_zone(v: float) -> void:
	dead_zone = v
	_redraw()

func set_adjustment_zone(v: float) -> void:
	adjustment_zone = v
	_redraw()
	
func set_target_angle(v: float) -> void:
	target_angle = v
	_redraw()

# Called when the node enters the scene tree for the first time.
func _redraw():
	if not dead_zone_node:
		dead_zone_node = get_node_or_null("Deadzone")
	if not adjustment_zone_node:
		adjustment_zone_node = get_node_or_null("AdjustmentZone")

	if dead_zone_node:
		_redraw_bounding_lines(dead_zone_node, dead_zone)
	if adjustment_zone_node:
		_redraw_bounding_lines(adjustment_zone_node, adjustment_zone)
	if target_angle_node:
		target_angle_node.clear_points()
		target_angle_node.add_point(Vector2.ZERO)
		target_angle_node.add_point(Vector2.RIGHT.rotated(target_angle) * radius)
	_redraw_debug_bg_circle()

func _redraw_bounding_lines(node, bounds) -> void:
	var i = -1
	for dz in node.get_children():
		if dz is Line2D:
			dz.clear_points()
			dz.add_point(Vector2.ZERO)
			dz.add_point(Vector2.RIGHT.rotated(bounds * i) * radius)
			i *= -1

func _redraw_debug_bg_circle() -> void:
	edge_node = get_node_or_null("Edge")
	fill_node = get_node_or_null("Fill")
	if not (edge_node and fill_node):
		return
	fill_node.polygons.clear()
	var points = PoolVector2Array()
	edge_node.clear_points()
	for i in range(360):
		if i % 4 != 0:
			continue
		var point = Vector2.UP.rotated(deg2rad(i)) * radius
		edge_node.add_point(point)
		points.append(point)
	fill_node.set_polygon(points)
	edge_node.add_point(Vector2.UP.rotated(deg2rad(0.5)) * radius)
