extends CharacterBody2D

const speed = 100
var current_dir = "none"

var in_attack_range = false
var in_attack_cooldown = true
var attack_in_progress = false

var health = 100
var is_alive = true

func _ready():
	if global.spawn_point == 'start':
		position = Vector2(60, 100)
	if global.spawn_point == 'exit_cliff':
		position = Vector2(400, 120)
	if global.spawn_point == 'enter_cliff':
		position = Vector2(10, 70)
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)
	get_damage()
	attack()
	update_health()
	
	if health <= 0:
		health = 0
		is_alive = false
		self.queue_free()

func player_movement(delta):
	if Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_animation(1)
		
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_animation(1)
		
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_animation(1)
		
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_animation(1)
		
		velocity.x = 0
		velocity.y = speed
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func set_player_pos(pos):
	position = pos

func play_animation(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "left":
		anim.flip_h = true
		if movement == 0:
			if attack_in_progress == false:
				anim.play("side_idle")
		elif movement == 1:
			anim.play("side_walk")
	
	if dir == "right":
		anim.flip_h = false
		if movement == 0:
			if attack_in_progress == false:
				anim.play("side_idle")
		elif movement == 1:
			anim.play("side_walk")
	
	if dir == "up":
		anim.flip_h = false
		if movement == 0:
			if attack_in_progress == false:
				anim.play("back_idle")
		elif movement == 1:
			anim.play("back_walk")
	
	if dir == "down":
		anim.flip_h = false
		if movement == 0:
			if attack_in_progress == false:
				anim.play("front_idle")
		elif movement == 1:
			anim.play("front_walk")

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		in_attack_range = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		in_attack_range = false

func player():
	pass

func get_damage():
	if in_attack_range and in_attack_cooldown:
		health -= 10
		in_attack_cooldown = false
		$attack_cooldown.start()
		print("player health:", health)

func _on_attack_cooldown_timeout():
	in_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.is_attacking = true
		attack_in_progress = true
		
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$attack_timer.start()
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$attack_timer.start()

func update_health():
	$ProgressBar.value = health
	
	if health >= 100:
		$ProgressBar.visible = false
	else:
		$ProgressBar.visible = true

func _on_attack_timer_timeout():
	$attack_timer.stop()

	global.is_attacking = false
	attack_in_progress = false

func _on_health_recovery_timeout():
	if health > 0 and health < 100:
		health += 20
