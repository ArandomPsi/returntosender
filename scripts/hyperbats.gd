extends Node2D

var dir : int = 1

func _ready() -> void:
	await get_tree().create_timer(0.4).timeout
	dir = -1
	await get_tree().create_timer(3).timeout
	queue_free()

func _process(delta: float) -> void:
	position += transform.x * dir * delta * 1500
