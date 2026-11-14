extends Node2D

var spinning : bool = false
var frames : int = 0


func _ready() -> void:
	if randi_range(1,2) == 2:
		$Sprite2D.scale.x *= -1
	$GPUParticles2D.emitting = true
	var tween = create_tween()
	
	tween.tween_property($Sprite2D,"rotation_degrees",-30 * $Sprite2D.scale.x/5,0.3).set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(0.2)
	
	await tween.finished
	global.player.camerashake += 10
	var tween2 = create_tween()
	tween2.tween_property($Sprite2D,"rotation",2*TAU * $Sprite2D.scale.x/5,0.8).set_trans(Tween.TRANS_CUBIC)
	spinning = true
	look_at(global.playerpos)
	$Sprite2D/spinny.emitting = true
	$Sprite2D/trail.visible = true
	await tween2.finished
	$Sprite2D/spinny.emitting = false
	$Sprite2D/trail.visible = false
	queue_free()
	var tween3 = create_tween()
	



func reflect():
	rotation += PI 
