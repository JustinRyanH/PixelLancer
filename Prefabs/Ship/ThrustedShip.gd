extends RigidBody2D

const PI_DIV_8 = PI / 8

export var thruster_power := 100.0
export var max_speed := 900.0
export var rotation_speed = 2.0
export var rotations_per_second = 1.0
export var stop_buffer := 0.05
export var thrust_curve: Curve

var _boost: bool = false
var _thrust: Vector2 = Vector2.ZERO
var _movement: Vector2 = Vector2.ZERO
onready var _target_rotation := rotation
onready var _time_til_target_rotation := 0.0

onready var look_crosshair: Node2D = $LookCrossHair
onready var thrusters: Thrusters = $Thrusters

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	Events.emit_signal("connect_ship", self)

func _process(delta: float) -> void:
	rotate_towards_mouse(delta)
	update_crosshairs()
	move_input()

func _physics_process(delta: float) -> void:
	if linear_velocity.length_squared() > max_speed * max_speed:
		linear_velocity = linear_velocity.clamped(max_speed)

	if _boost:
		apply_central_impulse(Vector2.RIGHT.rotated(rotation) * (max_speed * 0.5) * delta)

	if _thrust.length_squared() > 0:
		var direction_match := _thrust.normalized() - Vector2.RIGHT.rotated(rotation)
		var direction_multiplayer := (4.0 - direction_match.length_squared()) / 4.0
		direction_multiplayer = clamp(direction_multiplayer, 0.5, 1.0)
		apply_central_impulse(_thrust * thruster_power * direction_multiplayer * delta)

func rotate_towards_mouse(_delta: float) -> void:
	var mouse_rotation := get_local_mouse_position().angle()
	var target_dist = abs(mouse_rotation / PI)
	print(target_dist)
	
	if target_dist < stop_buffer:
		print("FOO")
		thrusters.rotation_direction = 0
		angular_velocity = lerp(angular_velocity, 0, 0.999)
	else:
		angular_velocity = sign(mouse_rotation) * rotation_speed
		thrusters.rotation_direction = int(sign(mouse_rotation))
		
func move_input() -> void:
	_thrust = Vector2.ZERO
	if Input.is_action_pressed("thrust_up"):
		_thrust.x += 1
	if Input.is_action_pressed("thrust_down"):
		_thrust.x -= 1
	if Input.is_action_pressed("thrust_left"):
		_thrust.y -= 1
	if Input.is_action_pressed("thrust_right"):
		_thrust.y += 1
	_boost = Input.is_action_pressed("boost")
	# Normalize the Thrust so that we don't get the
	# the quake strife bug
	_thrust = _thrust.normalized()
	_emit_thrusters(_thrust)
	_thrust = _thrust.rotated(rotation)

func update_crosshairs() -> void:
	var _mouse_pos = get_local_mouse_position().normalized()
	look_crosshair.position = _mouse_pos * 150.0
	look_crosshair.rotation_degrees = rad2deg(_mouse_pos.angle()) + 90.0


## Set Thrust Direction for Thruster Emission
# Thrust direction is relative to the screen, but when we emit we need to
# understand the rotation of the ship to decide which ones to turn on.
# First we rotate the _thrust vector in  the opposite rotation  of the ship rotation
# Then we reverse the thrust so that the thruster direction matches with the thruster
func _emit_thrusters(thrust: Vector2) -> void:
	thrusters.emission_vector = -thrust
	thrusters.boost = _boost
