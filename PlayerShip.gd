extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var thruster_particles = $ThrusterParticles

var _accelerating := false
var _turn := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_gather_input()
	thruster_particles.emitting = _accelerating
	rotate(_turn * delta)
	
func _gather_input() -> void:
	if Input.is_action_just_pressed("accelerate"):
		_accelerating =  true
	elif Input.is_action_just_released("accelerate"):
		_accelerating = false
	_turn = 0.0
	if Input.is_action_pressed("gyro_left"):
		_turn -= 1
	if Input.is_action_pressed("gyro_right"):
		_turn += 1
