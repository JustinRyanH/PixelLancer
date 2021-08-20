extends RigidBody2D

export var thruster_power := 100.0 setget set_thruster_power
export var max_speed := 900.0 setget set_max_speed


export var stop_buffer := 0.2 setget set_stop_buffer
export var rotation_speed := 2.0 setget set_rotation_speed


onready var look_crosshair: Node2D = $LookCrossHair
onready var rotator := $ShipRotator
onready var engine := $EngineController

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	Events.emit_signal("connect_ship", self)

func _process(_delta: float) -> void:
	update_crosshairs()

func update_crosshairs() -> void:
	var _mouse_pos = get_local_mouse_position().normalized()
	look_crosshair.position = _mouse_pos * 150.0
	look_crosshair.rotation_degrees = rad2deg(_mouse_pos.angle()) + 90.0

func set_thruster_power(value: float) -> void:
	thruster_power = value
	engine.thruster_power = value

func set_max_speed(value: float) -> void:
	max_speed = value
	engine.max_speed = value
	

func set_stop_buffer(value: float) -> void:
	stop_buffer = value
	rotator.set_stop_buffer = value

func set_rotation_speed(value: float) -> void:
	rotation_speed = value
	rotator.set_stop_buffer = value
