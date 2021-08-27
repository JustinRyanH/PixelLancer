extends RigidBody2D
class_name ThrustedShip

enum Movement { Standard, Decel }

export var thruster_power := 100.0
export var max_speed := 900.0

export var max_fuel := 200.0 setget set_max_fuel
export var fuel_recharge_delay: float = 1.0
onready var fuel := max_fuel setget set_fuel
onready var look_crosshair: Node2D = $LookCrossHair
onready var fuel_recharge_timer: Timer = $FuelRechargeTimer
onready var refuel_tween: Tween = $RefuelTween
onready var rotator := $ShipRotator
onready var engine := $EngineController

var boost := 0.0
var thrust := Vector2.ZERO
var rotation_target := Vector2.ZERO
var _movement_state: int = Movement.Standard

func _set_movement_state(next_state: int) -> void:
	if next_state == _movement_state:
		return
	match next_state:
		Movement.Decel:
			_movement_state = next_state
		Movement.Standard:
			_movement_state = next_state

func _ready():
	engine.max_speed = max_speed
	engine.thruster_power = thruster_power
	yield(get_tree().create_timer(0.5), "timeout")
	Events.emit_signal("connect_ship", self)

func _process(delta: float) -> void:
	match _movement_state:
		Movement.Decel:
			decel_process(delta)
		Movement.Standard:
			standard_process(delta)
	engine.boost = boost
	engine.thrust = thrust
	rotator.target = rotation_target
	update_crosshairs()

func decel_process(_delta: float) -> void:
	rotation_target = linear_velocity.normalized() * -1
	thrust = linear_velocity.normalized() * -1
	if thrust.distance_squared_to(Vector2.RIGHT.rotated(rotation)) < 0.002:
		boost = 0.25
	if linear_velocity.length_squared() < 1:
		linear_velocity = Vector2.ZERO
		_set_movement_state(Movement.Standard)

func standard_process(_delta: float) -> void:
	move_input()
	if Input.is_action_just_pressed("counter_velocity"):
		_set_movement_state(Movement.Decel)
	else:
		var target_position = (get_global_mouse_position() - global_position).normalized()
		rotation_target = target_position

func update_crosshairs() -> void:
	var _mouse_pos = get_local_mouse_position().normalized()
	look_crosshair.position = _mouse_pos * 150.0
	look_crosshair.rotation_degrees = rad2deg(_mouse_pos.angle()) + 90.0

func set_max_fuel(v: float) -> void:
	max_fuel = v

func set_fuel(v: float) -> void:
	refuel_tween.stop(self, "_update_fuel")
	fuel_recharge_timer.start(fuel_recharge_delay)
	fuel = v

func _update_fuel(v: float) -> void:
	fuel = v

func _on_FuelRechargeTimer_timeout():
	var recharge_time = 1 - (fuel / max_fuel)
	refuel_tween.interpolate_method(self, "_update_fuel", fuel, max_fuel, recharge_time)
	refuel_tween.start()

func move_input() -> void:
	var _thrust = Vector2.ZERO
	if Input.is_action_pressed("thrust_up"):
		_thrust.x += 1
	if Input.is_action_pressed("thrust_down"):
		_thrust.x -= 1
	if Input.is_action_pressed("thrust_left"):
		_thrust.y -= 1
	if Input.is_action_pressed("thrust_right"):
		_thrust.y += 1
	boost = 1.0 if Input.is_action_pressed("boost") else 0.0
	thrust = _thrust.normalized().rotated(rotation)
