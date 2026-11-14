extends Node2D
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	$GPUParticles2D.emitting = false
	$GPUParticles2D2.emitting = false
	await get_tree().create_timer(1).timeout
	queue_free()

func _process(delta: float) -> void:
	if $GPUParticles2D.emitting:
		global.player.camerashake = 8
