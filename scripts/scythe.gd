extends Node2D

var spinning : bool = false
var frames : int = 0


func _ready() -> void:
	if randi_range(1,2) == 2:
		$Sprite2D.scale.x *= -1
	$GPUParticles2D.emitting = true
	var tween = create_tween()
	
	tween.tween_property($Sprite2D,"rotation_degrees",-30 * $Sprite2D.scale.x/5,0.4).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(0.3)
	await tween.finished
	spinning = true
	look_at(global.playerpos)
	$fabababa/CollisionShape2D.disabled = false
	$Sprite2D/spinny.emitting = true
	$Sprite2D/trail.visible = true

func _process(delta: float) -> void:
	if spinning:
		frames += 1
		$Sprite2D.rotation += 40 * delta * $Sprite2D.scale.x/5
		position += 700 * delta * transform.x
		if frames > 300:
			queue_free()

func reflect():
	rotation += PI 
