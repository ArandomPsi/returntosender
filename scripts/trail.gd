extends Line2D
var queue : Array
@export var MAX_LENGTH : int


func _process(_delta) -> void:
	position =  -get_parent().position
	var pos = get_parent().global_position
	queue.push_front(pos)
	if queue.size() > MAX_LENGTH:
		queue.pop_back()
	clear_points() #clear old thing
	for point in queue: #update
		add_point(point)
