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
	
	$Node2D/wing1.rotation_degrees = sin(t * 5) * 10
	
	
	if hitstun >= 1:
		hitstun -= 1
	#if not $AnimationPlayer.is_playing():
		#if randi_range(1,3) == 1:
			#$AnimationPlayer.play("lightbeam")
		#else:
			#if randi_range(1,2) == 1:
				#$AnimationPlayer.play("scythetoss")
			#else:
				#$AnimationPlayer.play("scythemelee")
	
	if not nomove:
		$pivot.look_at(targetpos)
		
		velocity += $pivot.transform.x * 20
	
	move_and_slide()
	velocity *= 0.9

func damage(amount):
	hp -= 1
	hitstun = 8



func togglemovement():
	nomove = not nomove
#random movement stuff

func _on_timer_timeout() -> void:
	targetpos = Vector2(randi_range(0,1152),randi_range(300,500))
	$Timer.start(randf_range(2,4))

func scythedash():
	var targetpospos : Vector2 = global.playerpos
	while position.distance_to(targetpospos) > 80:
		nomove = true
		$pivot/dasher.emitting = true
		$pivot.look_at(targetpospos)
		velocity += $pivot.transform.x * 800
		if hitstun > 1:
			break
		await get_tree().process_frame
	
	$pivot/dasher.emitting = false
	await get_tree().create_timer(0.2)
	nomove = false
