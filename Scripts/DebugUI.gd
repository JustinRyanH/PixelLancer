extends Control

onready var speed_value_label: Label = $SpeedValue
var _main_ship: RigidBody2D = null

func _ready():
	var err = Events.connect("connect_ship", self, "_connect_ship")
	if err != OK:
		print("Failed to Connect, `connect_ship` for %s" % self)

func _connect_ship(ship: RigidBody2D) -> void:
	_main_ship = ship
	
func _process(_delta:  float) -> void:
	if _main_ship:
		speed_value_label.text = "%2.f" % _main_ship.linear_velocity.length() 
