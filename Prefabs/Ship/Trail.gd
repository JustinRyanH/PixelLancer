extends Line2D

export var target_path: NodePath
export var max_points := 32
## TODO: This resolution needs to be slightly varaible.
# Sharp Turns create akward bends that can be fixed with higher
# resolution. 
export var resolution := 5.0
export var life_time := 0.75

onready var target: Node2D = get_node_or_null(target_path)

var _point_creation_time := []
var _clock := 0.0

func _ready():
	if not target:
		target = get_parent() as Node2D
	
	set_as_toplevel(true)
	position = Vector2.ZERO
	clear_points()
	_point_creation_time.clear()
	
func _process(delta: float) -> void:
	_clock += delta
	_remove_older_points()
	
	if get_point_count() == 0:
		add_point(_target_position(), 0)
		return
		
	var desired_point := _target_position()
	var distance := get_point_position(0).distance_to(desired_point)
	if  distance >  resolution:
		_add_timed_point(desired_point, _clock)
	
	if get_point_count() > max_points:
		_remove_last_point()
		
func _remove_older_points() -> void:
	for creation_time in _point_creation_time:
		var delta = _clock - creation_time
		if delta > life_time:
			_remove_last_point()
		else:
			break
	
func _add_timed_point(point: Vector2, time: float) -> void:
	add_point(point, 0)
	_point_creation_time.append(time)

func _remove_last_point() -> void:
	if get_point_count() >= 1:
		remove_point(get_point_count() - 1)
		_point_creation_time.pop_front()

func _target_position() -> Vector2:
	return to_local(target.global_position)