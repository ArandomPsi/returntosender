extends CharacterBody2D

#godslayer game: boss rush. Kill everyone in the dnd 9 hells and every upper god
#rougelike


var movedir : float

var speed : int = 9500

var attackcooldown : int = 0
var consecutiveslashdir : int = 1

var spell1 : int = 0 #reap, firebolt

var hp : int = 5

var camerashake : int = 0

var hitcombo : int = 0

var parryframes : int = 0
var iframes : int = 0

func _ready() -> void:
	hp = 5
	global.player = self
	var tween = create_tween()
	tween.tween_property($hud/ColorRect,"color:a",0.0,0.8).set_trans(Tween.TRANS_CUBIC)

func _process(delta: float) -> void:
	global.playerpos = position
	attackcooldown -= 1
	
	$hud/hp.value = hp
	
	camerashake -= 1
	iframes -= 1
	camerashake = clamp(camerashake,0,20)
	parryframes -= 1
	parryframes = clamp(parryframes,0,60)
	
	if not $AnimationPlayer.is_playing():
		attackcontrols()
		movementcontrols()
		updatevisuals()
	updatepos(delta)

	createtrail(0.1)
	
	if is_on_floor():
		hitcombo = 0
		$hud/combometer.modulate.a = lerp($hud/combometer.modulate.a,0.0,0.1)
	else:
		$hud/combometer.modulate.a = lerp($hud/combometer.modulate.a,1.0,0.1)
		$hud/combometer.text = str(hitcombo) + "x"
	$hud/combometer.scale = lerp($hud/combometer.scale,Vector2(1,1),0.1)
	

func attackcontrols():
	if Input.is_action_just_pressed("basicattack") and attackcooldown < 1:
		slash()
		camerashake =6
		

func movementcontrols():
	movedir = Input.get_axis("left","right")
	
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = -800
	
	if Input.is_action_just_released("up") and velocity.y < 0:
		velocity.y *= 0.5
	
	
	


func updatepos(delta):
	
	velocity.x += movedir * speed * delta
	velocity.x *= 0.85
	
	velocity.y += 1500 * delta
	
	move_and_slide()
	


func updatevisuals():
	normalanimations()
	$Camera2D.offset = Vector2(randf_range(-1,1),randf_range(-1,1)) * camerashake/1

func normalanimations():
	if movedir > 0:
		$flip.scale.x = 1
	elif movedir < 0:
		$flip.scale.x = -1
	
	var state = "idle"
	
	if not movedir == 0: state = "walk"
	
	if not is_on_floor():
		if velocity.y > 0:
			state = "fall"
		elif velocity.y <= 0:
			state = "up"
	
	match state:
		"idle":
			$flip/sprite.play("idle")
		"walk":
			$flip/sprite.play("walk")
		"fall":
			$flip/sprite.play("fall")
		"up":
			$flip/sprite.play("up")
	


func handthrow():
	$pivot/hand.visible = true
	$pivot/hand.rotation_degrees = -150.0 * consecutiveslashdir
	var tween = create_tween()
	tween.tween_property($pivot/hand,"rotation_degrees",150 * consecutiveslashdir,0.2).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	$pivot/hand.visible = false
	consecutiveslashdir *= -1


func slash():
	var v = Input.get_vector("left","right","up","down")
	if not v == Vector2.ZERO:
		$pivot.rotation = Input.get_vector("left","right","up","down").angle()
	else:
		$pivot.rotation = Vector2($flip.scale.x,0).angle()
	
	var b = preload("res://scenes/slash.tscn").instantiate()
	add_child(b)
	b.scale.y = $flip.scale.x
	b.rotation = $pivot.rotation
	attackcooldown = 30
	parryframes = 20
	velocity = $pivot.transform.x * 800
	

func createtrail(time : float):
	var b = preload("res://scenes/spritetrail.tscn").instantiate()
	b.time = time
	get_tree().current_scene.add_child(b)
	b.global_position = $flip/sprite.global_position
	b.scale = $flip/sprite.global_scale
	b.rotation = $flip/sprite.global_rotation
	b.sprite_frames = $flip/sprite.sprite_frames.duplicate()
	b.animation = $flip/sprite.animation
	b.frame = $flip/sprite.frame

func spawnparry(pos):
	var b = preload("res://scenes/hitfx.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	b.position = pos

func takedamage():
	if iframes < 1:
		spawnparry(global_position)
		if parryframes < 1:
			camerashake += 20
			$parry.play()
			hp -= 1
			var b = preload("res://scenes/hitsound.tscn").instantiate()
			get_tree().current_scene.add_child(b)
			iframes = 10
		else:
			
			spawncircles()
			if randi_range(1,5) == 1:
				hp += 1
			hp = clamp(hp,0,5)
			parryframes = 2
			attackcooldown = 0
			iframes = 20
		if hp < 1:
			$AnimationPlayer.play("die")

func spawncircles():
	var b = preload("res://scenes/counter.tscn").instantiate()
	add_child(b)
	

func addcombo():
	hitcombo += 1
	$hud/combometer.scale = Vector2(1,1) * 2

func challenge():
	$AnimationPlayer.play("challenge")

func hub():
	get_tree().change_scene_to_file("res://scenes/hub.tscn")

func shakea():
	camerashake += 20
