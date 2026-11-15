extends Node2D


func _on_sprite_animation_finished() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_parent().addcombo()
