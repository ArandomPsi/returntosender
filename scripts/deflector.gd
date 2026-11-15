extends Area2D



func _on_body_entered(body: Node2D) -> void:
	
	if body.has_method("reflect"):
		body.reflect()
		var b = load("res://scenes/hitsound.tscn").instantiate()
		get_tree().current_scene.add_child(b)
		
	else:
		body.velocity += global_transform.x * 800
		body.damage(1 + get_parent().get_parent().hitcombo/1.5)
		
		if get_parent().has_method("fabababa"):
			get_parent().fabababa()
		
	
	global.player.velocity = global_transform.x * -600
	global.player.camerashake += 12
	global.player.spawnparry((body.global_position + global_position) / 2)
