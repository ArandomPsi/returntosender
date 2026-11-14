extends AnimatedSprite2D
var time : float = 0.2
func _ready() -> void:
	material = material.duplicate()
	var tween = create_tween()
	tween.tween_method(setparam,1.0,0.0,time)
	await tween.finished
	queue_free()

func setparam(val : float):
	material.set_shader_parameter("alpha",val)
