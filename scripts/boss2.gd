extends CharacterBody2D

var hp : int = 50

var targetpos : Vector2 = Vector2(1152,648)/2

var nomove : bool = false

var hitstun : int = 0

var t : float

func _ready() -> void:
	$AnimationPlayer.play("intro")

func _process(delta: float) -> void:
	t+=delta
	if global.playerpos.x > position.x:
		$Node2D.scale.x = 1
	else:
	
		$Node2D.scale.x = -1
	$hud/hp.value = hp
	
	$Node2D/wing1.rotation_degrees = sin(t * 4) * 20
	$Node2D/wing2.rotation_degrees = -$Node2D/wing1.rotation_degrees
	
	if hitstun >= 1:
		hitstun -= 1
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("dash")
		#if randi_range(1,3) == 1:
			#$AnimationPlayer.play("lightbeam")
		#else:
			#if randi_range(1,2) == 1:
				#$AnimationPlayer.play("scythetoss")
			#else:
				#$AnimationPlayer.play("scythemelee")
	
	if not nomove:
		$pivot.look_at(targetpos)
		
		velocity += $pivot.transform.x * 50
	
	move_and_slide()
	velocity *= 0.95

func damage(amount):
	hp -= 1
	hitstun = 8



func togglemovement():
	nomove = not nomove
#random movement stuff

func _on_timer_timeout() -> void:
	targetpos = Vector2(randi_range(0,1152),randi_range(300,500))
	$Timer.start(randf_range(0.2,0.4))

func scythedash():
	var targetpospos : Vector2 = global.playerpos
	while position.distance_to(targetpospos) > 80:
		nomove = true
		
		$pivot.look_at(targetpospos)
		velocity += $pivot.transform.x * 300
		if hitstun > 1:
			break
		await get_tree().process_frame
	velocity*=0.3
	await get_tree().create_timer(0.2)
	

func goaboveplayer():
	var tween = create_tween()
	tween.tween_property(self,"position:x",global.playerpos.x,0.5).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(self,"position:y",10,0.5).set_trans(Tween.TRANS_CUBIC)

func dive():
	velocity.y = 3000
	await $Area2D.body_entered
	var b = preload("res://scenes/burst.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	b.position = position

func spawnbeam():
	var b = preload("res://scenes/dasher.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	b.position = position

func slash():
	var b = preload("res://scenes/swordcircle.tscn").instantiate()
	$Node2D.add_child(b)
