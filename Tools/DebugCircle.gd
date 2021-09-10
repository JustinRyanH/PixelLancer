tool
extends Node2D
class_name DebugAngleCircle

export var radius := 1.0 setget set_radius
export var dead_zone := 0.2 setget set_dead_zone
export var adjustment_zone := 0.4 setget set_adjustment_zone
export var overshoot_zone := PI / 2 setget set_overshoot_zone
export var target_angle := 0.0 setget set_target_angle
onready var dead_zone_node := $Deadzone
onready var adjustment_zone_node := $AdjustmentZone
onready var overshoot_zone_node := $OvershootZone
onready var target_angle_node := $TargetAngle
onready var fill_node := $CircleFill
onready var edge_node := $CircleEdge

func set_radius(v: float) -> void:
	print("SET RADIUS")
	radius = v
	if edge_node:
		edge_node.radius = v
	if fill_node:
		fill_node.radius = v
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
	
func set_overshoot_zone(v: float) -> void:
	overshoot_zone = v
	_redraw()
	
# Called when the node enters the scene tree for the first time.
func _redraw():
	if not dead_zone_node:
		dead_zone_node = get_node_or_null("Deadzone")
	if not adjustment_zone_node:
		adjustment_zone_node = get_node_or_null("AdjustmentZone")
	if not overshoot_zone_node:
		overshoot_zone_node = get_node_or_null("OvershootZone")
		
	if dead_zone_node:
		_redraw_bounding_lines(dead_zone_node, dead_zone)
	if adjustment_zone_node:
		_redraw_bounding_lines(adjustment_zone_node, adjustment_zone)
	if overshoot_zone_node:
		_redraw_bounding_lines(overshoot_zone_node, overshoot_zone)
	if target_angle_node:
		target_angle_node.clear_points()
		target_angle_node.add_point(Vector2.ZERO)
		target_angle_node.add_point(Vector2.RIGHT.rotated(target_angle) * radius)

func _redraw_bounding_lines(node, bounds) -> void:
	var i = -1
	for dz in node.get_children():
		if dz is Line2D:
			dz.clear_points()
			dz.add_point(Vector2.ZERO)
			dz.add_point(Vector2.RIGHT.rotated(bounds * i) * radius)
			i *= -1