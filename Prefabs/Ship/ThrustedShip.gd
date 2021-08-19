extends RigidBody2D

onready var look_crosshair: Node2D = $LookCrossHair

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	Events.emit_signal("connect_ship", self)

func _process(_delta: float) -> void:
	update_crosshairs()

func update_crosshairs() -> void:
	var _mouse_pos = get_local_mouse_position().normalized()
	look_crosshair.position = _mouse_pos * 150.0
	look_crosshair.rotation_degrees = rad2deg(_mouse_pos.angle()) + 90.0
