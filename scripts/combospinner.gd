extends Node2D

func _ready() -> void:
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true


func _on_gpu_particles_2d_finished() -> void:
	queue_free()
