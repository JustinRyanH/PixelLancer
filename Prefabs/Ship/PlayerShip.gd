extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var thruster_particles = $Thrusters
onready var collision_polygon = $CollisionPolygon2D

export var thruster_force := 1.0
export var rotation_factor := 1.0
export var max_speed := 750

var _accelerating := false
var _turn := 0.0

var linear_velocity := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_gather_input()
	thruster_particles.emitting = _accelerating
	_handle_velocity(delta)
	rotate(_turn * rotation_factor * delta)
	var _collision = move_and_collide(linear_velocity * thruster_force * delta)

func _handle_velocity(_delta: float) -> void:
	if _accelerating:
		var direction = Vector2.UP.rotated(rotation)
		linear_velocity += direction
	if linear_velocity.length_squared() > max_speed*max_speed:
		linear_velocity = linear_velocity.clamped(max_speed)
	var vt_position = linear_velocity.normalized().tangent()
	var port_closted_point = find_closest_point(vt_position *  10.0)
	var starboard_closet_point = find_closest_point(vt_position * -10.0)
	$PortTrail.position = port_closted_point["closest_point"]
	$StarboardTrail.position = starboard_closet_point["closest_point"]

func find_closest_point(tangent: Vector2) -> Dictionary:
	var to_return = {}
	var closted_point = null
	for point in collision_polygon.polygon:
		var rotated_point: Vector2 = point.rotated(rotation)
		if not closted_point:
			closted_point = point
		if (rotated_point + tangent).length() > (closted_point.rotated(rotation) + tangent).length():
			closted_point = point
	to_return["closest_point"] = closted_point
	return to_return

func _gather_input() -> void:
	if Input.is_action_just_pressed("accelerate"):
		_accelerating =  true
	elif Input.is_action_just_released("accelerate"):
		_accelerating = false
	_turn = 0.0
	if Input.is_action_pressed("gyro_left"):
		_turn -= 1
	if Input.is_action_pressed("gyro_right"):
		_turn += 1
