extends Line2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var target_path: NodePath
export var max_points := 32
export var resolution := 10.0

onready var target: Node2D = get_node_or_null(target_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	if not target:
		target = get_parent() as Node2D
	
	set_as_toplevel(true)
	position = Vector2.ZERO
	clear_points()
	
func _process(delta: float) -> void:
	if get_point_count() == 0:
		add_point(_target_position(), 0)
		return
		
	var desired_point := _target_position()
	var distance := get_point_position(0).distance_to(desired_point)
	if  distance >  resolution:
		add_point(desired_point, 0)
	
	if get_point_count() > max_points:
		remove_point(get_point_count() - 1)
	
func _target_position() -> Vector2:
	return to_local(target.global_position)

func _on_Timer_timeout():
	print("POOP")
