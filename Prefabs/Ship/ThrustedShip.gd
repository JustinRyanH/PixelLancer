extends RigidBody2D

const PI_DIV_8 = PI / 8

export var thruster_power := 100.0
export var rotation_speed = 1.0
export var stop_buffer := 0.01

var _thrust: Vector2 = Vector2.ZERO
var _movement: Vector2 = Vector2.ZERO

onready var look_crosshair: Node2D = $LookCrossHair

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	Events.emit_signal("connect_ship", self)

func _process(delta: float) -> void:
	rotate_towards_mouse(delta)
	update_crosshairs()
	move_input()

func _physics_process(delta: float) -> void:
	apply_central_impulse(_thrust * thruster_power *  delta)

func rotate_towards_mouse(delta: float) -> void:
	var _mouse_rotation := get_local_mouse_position().angle()
	if abs(_mouse_rotation) > 1.0:
		angular_velocity = _mouse_rotation * rotation_speed
	elif abs(_mouse_rotation) > stop_buffer:
		angular_velocity = sign(_mouse_rotation) * rotation_speed
	else:
		angular_velocity = 0.0

func move_input() -> void:
	_thrust = Vector2.ZERO
	if Input.is_action_pressed("thrust_left"):
		_thrust.x -= 1
	if Input.is_action_pressed("thrust_right"):
		_thrust.x += 1
	if Input.is_action_pressed("thrust_up"):
		_thrust.y -= 1
	if Input.is_action_pressed("thrust_down"):
		_thrust.y += 1
	# Normalize the Thrust so that we don't get the 
	# the quake strife bug 
	_thrust.normalized()

func update_crosshairs() -> void:
	var _mouse_pos = get_local_mouse_position().normalized()
	look_crosshair.position = _mouse_pos * 150.0
	look_crosshair.rotation_degrees = rad2deg(_mouse_pos.angle()) + 90.0
