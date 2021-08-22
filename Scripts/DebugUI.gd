extends Control

onready var speed_value_label: Label = $SpeedValue
onready var angular_velocity_label: Label = $VSplitContainer/AngularVelocity/Value
onready var angular_damping_label: Label = $VSplitContainer/AngularDamping/Value
onready var angular_damping_slider: HSlider = $VSplitContainer/AngularDamping/HSlider
var _main_ship: RigidBody2D = null

func _ready():
	var err = Events.connect("connect_ship", self, "_connect_ship")
	if err != OK:
		print("Failed to Connect, `connect_ship` for %s" % self)


func _connect_ship(ship: RigidBody2D) -> void:
	_main_ship = ship

func _process(_delta:  float) -> void:
	if _main_ship:
		update_main_ship()

func update_main_ship() -> void:
	speed_value_label.text = "%2.f" % _main_ship.linear_velocity.length()
	angular_velocity_label.text = "%2.2f" % _main_ship.angular_velocity
	angular_damping_label.text = "%2.2f" % _main_ship.angular_damp
	angular_damping_slider.value = _main_ship.angular_damp


func _on_damping_changed(value):
	if _main_ship:
		_main_ship.angular_damp = value
