extends Control

onready var fuel_progress_bar: ProgressBar = $Ship/FuelBox/FuelBar
onready var fuel_recharge: ProgressBar = $Ship/FuelBox/RechargeBar
onready var speed_value_label: Label = $Ship/SpeedBox/SpeedValue
onready var debug_checkbox: CheckBox = $RotationSection/DebugMode/CheckBox
var _main_ship: ThrustedShip = null

func _ready():
	var err = Events.connect("connect_ship", self, "_connect_ship")
	if err != OK:
		print("Failed to Connect, `connect_ship` for %s" % self)


func _connect_ship(ship: RigidBody2D) -> void:
	_main_ship = ship
	fuel_progress_bar.max_value = ship.max_fuel
	fuel_recharge.max_value = ship.fuel_recharge_timer.wait_time

func _process(_delta:  float) -> void:
	debug_checkbox.pressed = Debug.is_debug
	if _main_ship:
		update_main_ship()

func update_main_ship() -> void:
	speed_value_label.text = "%2.f" % _main_ship.linear_velocity.length()
	fuel_progress_bar.value = _main_ship.fuel
	fuel_recharge.value = _main_ship.fuel_recharge_timer.time_left

func _on_Debug_CheckBox_toggled(button_pressed: bool):
	Debug.is_debug = button_pressed
