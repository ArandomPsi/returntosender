extends Node2D


func _on_boomba_3_finished() -> void:
	$attackbox/CollisionShape2D.disabled = false
	$boomba.emitting = true
	$boomba3.emitting = true
	$boombawe.emitting = true
	
	await get_tree().create_timer(1).timeout
	$boomba.emitting = false
	$boomba3.emitting = false
	$attackbox/CollisionShape2D.disabled = true
	
	await get_tree().create_timer(0.7).timeout
	queue_free()
