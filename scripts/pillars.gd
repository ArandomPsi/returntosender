extends Sprite2D
@export var scene : String
@export var fade : ColorRect
func _process(delta: float) -> void:
	
	if $Area2D.has_overlapping_bodies():
		if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
			global.player.challenge()
			var tween = create_tween()
			tween.tween_property(fade,"color:a",1.0,1).set_delay(1)
			await tween.finished
			get_tree().change_scene_to_file(scene)
		$Label.modulate.a = lerpf($Label.modulate.a,1.0,0.1)
	else:
		$Label.modulate.a = lerpf($Label.modulate.a,0.0,0.1)
