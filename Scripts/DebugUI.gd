extends Control

onready var fuel_progress_bar: ProgressBar = $FuelBar
onready var speed_value_label: Label = $SpeedValue
onready var angular_velocity_label: Label = $RotationSection/AngularVelocity/Value
onready var angular_damping_label: Label = $RotationSection/AngularDamping/Value
onready var angular_damping_slider: HSlider = $RotationSection/AngularDamping/HSlider
onready var rotation_state_label: Label = $RotationSection/RotationState/State
var _main_ship: ThrustedShip = null

func _ready():
	var err = Events.connect("connect_ship", self, "_connect_ship")
	if err != OK:
		print("Failed to Connect, `connect_ship` for %s" % self)


func _connect_ship(ship: RigidBody2D) -> void:
	_main_ship = ship
	fuel_progress_bar.max_value = ship.max_fuel

func _process(_delta:  float) -> void:
	if _main_ship:
		update_main_ship()

func update_main_ship() -> void:
	speed_value_label.text = "%2.f" % _main_ship.linear_velocity.length()
	angular_velocity_label.text = "%2.2f" % _main_ship.angular_velocity
	angular_damping_label.text = "%2.2f" % _main_ship.angular_damp
	angular_damping_slider.value = _main_ship.angular_damp
	fuel_progress_bar.value = _main_ship.fuel
	update_rotation_state()

func update_rotation_state() -> void:
	var rotator: ShipRotatorV2 = _main_ship.get_node("ShipRotator")
	var index = rotator._rotation_state
	rotation_state_label.text = rotator.RotationState.keys()[index]

func _on_damping_changed(value):
	if _main_ship:
		_main_ship.angular_damp = value
