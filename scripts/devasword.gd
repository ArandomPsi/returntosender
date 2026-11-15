extends Node2D

var phase : int = 0

func _ready() -> void:
	scale = Vector2(0,0)
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1),0.8).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	phase = 1
	await get_tree().create_timer(0.8).timeout
	phase = 2
	await get_tree().create_timer(2).timeout
	queue_free()

func _process(delta: float) -> void:
	match phase:
		0:
			rotation_degrees += 36
		1:
			var v = (global.playerpos - global_position).angle()
			rotation = lerp_angle(rotation,v,0.1)
		2:
			position += transform.x * 1200 * delta

func reflect():
	rotation += PI 
