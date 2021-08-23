extends Node2D
class_name ShipRotator


const ANGULAR_VELOCITY_DEAD_ZONE := 0.1
export var dead_zone := 0.2
export var adjustment_zone := 1.0
export var rotation_speed := 75.0
export var max_rotation_speed := 8.0

onready var parent: RigidBody2D = get_parent()
onready var rotate_port: RotationThruster = parent.get_node("RotationPort")
onready var rotate_starboard: RotationThruster = parent.get_node("RotationStarboard")

var _target_angle: float = 0.0
var _target_angle_sign: int = 0
var _adjusted_dead_zone: float = dead_zone
