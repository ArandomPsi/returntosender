extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.has_method("reflect"):
		body.reflect()
	else:
		body.velocity += global_transform.x * 800
		body.hp -= 1 + get_parent().get_parent().hitcombo/2
		get_parent().fabababa()
		
	
	global.player.velocity = global_transform.x * -600
	global.player.camerashake += 12
	global.player.spawnparry((body.global_position + global_position) / 2)
