extends RigidBody2D
class_name ThrustedShip

export var thruster_power := 100.0
export var max_speed := 900.0

export var max_fuel := 200.0 setget set_max_fuel
onready var fuel := max_fuel
onready var look_crosshair: Node2D = $LookCrossHair
onready var rotator := $ShipRotator
onready var engine := $EngineController

func _ready():
	engine.max_speed = max_speed
	engine.thruster_power = thruster_power
	yield(get_tree().create_timer(0.5), "timeout")
	Events.emit_signal("connect_ship", self)

func _process(_delta: float) -> void:
	update_crosshairs()

func update_crosshairs() -> void:
	var _mouse_pos = get_local_mouse_position().normalized()
	look_crosshair.position = _mouse_pos * 150.0
	look_crosshair.rotation_degrees = rad2deg(_mouse_pos.angle()) + 90.0

func set_max_fuel(v: float) -> void:
	max_fuel = v
