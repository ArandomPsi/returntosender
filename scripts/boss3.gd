extends CharacterBody2D

var hp : int = 50

var targetpos : Vector2 = Vector2(1152,648)/2

var nomove : bool = false

var hitstun : int = 0

var t : float

var omiowaoshinderu : bool = false

func _ready() -> void:
	$AnimationPlayer.play("intro")

func _process(delta: float) -> void:
	t+=delta
	if global.playerpos.x > position.x:
		$Node2D.scale.x = 1
	else:
	
		$Node2D.scale.x = -1
	$hud/hp.value = hp
	
	$Node2D/wing1.rotation_degrees = sin(t * 5) * 38
	$Node2D/wing2.rotation_degrees = -$Node2D/wing1.rotation_degrees
	
	if hitstun >= 1:
		hitstun -= 1
	if not $AnimationPlayer.is_playing():
		
		if randi_range(1,5) == 1:
			$AnimationPlayer.play("hyperbats")
		else:
			if randi_range(1,2) == 1:
				$AnimationPlayer.play("combospinner")
			else:
				$AnimationPlayer.play("dash")
	
	if not nomove:
		$pivot.look_at(targetpos)
		
		velocity += $pivot.transform.x * 50
	
	move_and_slide()
	velocity *= 0.95

func damage(amount):
	hp -= amount
	var b = preload("res://scenes/hitsound.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	if hp < 1 and not omiowaoshinderu:
		omiowaoshinderu = true
		get_tree().current_scene.add_child(b)
		$AnimationPlayer.play("die")
		
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

func dashtoplayer():
	velocity *= 0
	targetpos = global.playerpos
	$pivot.look_at(targetpos)
	
	var b = preload("res://scenes/mortisslash.tscn").instantiate()
	add_child(b)
	b.look_at(targetpos)
	
	nomove = true
	velocity = $pivot.transform.x * 2500
	await get_tree().create_timer(0.3)
	velocity *= 0.6
	nomove = false

func dive():
	velocity.y = 4000
	await $Area2D.body_entered
	var b = preload("res://scenes/burst.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	b.position = position
	global.player.camerashake += 15

func diddyblud():
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
	global.player.camerashake += 8

func createswordcircle():
	var playerpos : Vector2 = position
	for i in range(10):
		var angle = deg_to_rad(i * 36)
		var offset = Vector2(cos(angle), sin(angle)) * 50 + Vector2(0,-25)
		createswordonplayer(offset,playerpos)
		
		
		

func createswordonplayer(offset : Vector2,pos : Vector2):
	var b = preload("res://scenes/devasword.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	b.position = pos + offset


func cratecircleonplayer():
	var playerpos : Vector2 = global.playerpos
	for i in range(20):
		var angle = deg_to_rad(i * 36)
		var offset = Vector2(cos(angle), sin(angle)) * (200 + (i*10)) + Vector2(0,-100 - (i*5))
		createswordonplayer(offset,playerpos)
		
		for e in range(10):
			await get_tree().process_frame
		


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer2.play()

func screenshakethingy():
	for i in range(60):
		global.player.camerashake = 20
		await get_tree().process_frame

func hub():
	get_tree().change_scene_to_file("res://scenes/hub.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	nomove = false


func createcombospinner():
	var b = preload("res://scenes/combospinner.tscn").instantiate()
	add_child(b)
	#create the combo spinner offset thingy
	$pivot.look_at(global.playerpos)
	b.position += $pivot.transform.x * 100

func hyperbats():
	var b = load("res://scenes/hyperbats.tscn").instantiate()
	get_parent().add_child(b)
	b.position = position
	b.look_at(global.playerpos)

func smallshake():
	global.player.camerashake = 5
