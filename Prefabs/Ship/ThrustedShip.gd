extends RigidBody2D
class_name ThrustedShip

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

func _ready():
	engine.max_speed = max_speed
	engine.thruster_power = thruster_power
	yield(get_tree().create_timer(0.5), "timeout")
	Events.emit_signal("connect_ship", self)

func _process(_delta: float) -> void:
	update_crosshairs()
	rotator.target_angle = get_local_mouse_position().angle()

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
