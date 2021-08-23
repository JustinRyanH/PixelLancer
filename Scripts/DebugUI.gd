extends Control

onready var fuel_progress_bar: ProgressBar = $FuelBar
onready var speed_value_label: Label = $SpeedValue
onready var target_angle_label: Label = $RotationSection/TargetAngle/Value
onready var actual_angle_label: Label = $RotationSection/ActualAngle/Value
onready var angular_velocity_label: Label = $RotationSection/AngularVelocity/Value
onready var angular_damping_label: Label = $RotationSection/AngularDamping/Value
onready var angular_damping_slider: HSlider = $RotationSection/AngularDamping/HSlider
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
	actual_angle_label.text = "%2.4f" % _main_ship.rotation
	fuel_progress_bar.value = _main_ship.fuel
	var rotator: ShipRotatorV2 = _main_ship.get_node("ShipRotator")
	if rotator:
		target_angle_label.text = "%2.4f" % rotator._target_angle

func _on_damping_changed(value):
	if _main_ship:
		_main_ship.angular_damp = value
