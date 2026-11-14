extends CharacterBody2D

var hp : int = 50

var targetpos : Vector2 = Vector2(1152,648)/2

var nomove : bool = false

var hitstun : int = 0

func _ready() -> void:
	$AnimationPlayer.play("intro")

func _process(delta: float) -> void:
	if hitstun >= 1:
		hitstun -= 1
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("lightbeam")
	
	if not nomove:
		$pivot.look_at(targetpos)
		
		velocity += $pivot.transform.x * 20
	
	move_and_slide()
	velocity *= 0.9

func damage(amount):
	hp -= 1
	hitstun = 8

func spawnscythetoss():
	var b = load("res://scenes/scythe.tscn").instantiate()
	
	get_tree().current_scene.add_child(b)
	b.position = position


func spawnspawnthingy():
	var b = load("res://scenes/angelspawn.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	b.position = position


func move(vector : Vector2,time : int):
	for i in range(time):
		velocity += vector
		await get_tree().process_frame

func lightdashthing():
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(1152,648)/2,0.5).set_trans(Tween.TRANS_CUBIC)
	
	var c = preload("res://scenes/burst.tscn").instantiate()
	get_tree().current_scene.add_child(c)
	c.position = position
	nomove = true
	
	var b = preload("res://scenes/bouncething.tscn").instantiate()
	get_tree().current_scene.add_child(b)
	b.position = Vector2(1152,648)/2
	b.rotation = $pivot.rotation
	b.parent = self

func trippledash(points : Array):
	visible = true
	var c = preload("res://scenes/burst.tscn").instantiate()
	get_tree().current_scene.add_child(c)
	c.position = position
	nomove = true
	
	for i in range(points.size()):
		$pivot/dasher.emitting = true
		while position.distance_to(points[i]) > 80:
			print(str(position.distance_to(points[i])))
			$pivot.look_at(points[i])
			velocity += $pivot.transform.x * 800
			if hitstun > 1:
				break
			await get_tree().process_frame
		if hitstun > 1:
				break
		
		nomove = true
		global.player.camerashake =20
		velocity *= 0
		$pivot/dasher.emitting = false
		await get_tree().create_timer(0.1).timeout
		
	nomove = false
	$pivot/dasher.emitting = false

func togglemovement():
	nomove = not nomove
#random movement stuff

func _on_timer_timeout() -> void:
	targetpos = Vector2(randi_range(0,1152),randi_range(300,500))
	$Timer.start(randf_range(2,4))
