extends Node2D

var points : Array = []
var parent : Node
var amount : int = 0


func _process(delta: float) -> void:
	
	if points.size() < 3:
		$Line2D.add_point(global_position)
		position += 3000 * delta * transform.x
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	rotation_degrees += 200 + randi_range(-20,20)
	
	amount += 1
	points.push_back(global_position)
	if amount >= 3:
		parent.trippledash(points)
		print(str(points))
		queue_free()
	
