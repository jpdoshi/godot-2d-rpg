extends CharacterBody2D

var speed = 40
var health = 100

var chase_player = false
var player = null

var can_take_damage = true
var in_attack_zone = false

func _physics_process(delta):
	get_damage()
	
	if chase_player:
		position += (player.position - position) / speed
		$AnimatedSprite2D.play("walk")
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	chase_player = true


func _on_detection_area_body_exited(body):
	player = null
	chase_player = false

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if (body.has_method("player")):
		in_attack_zone = true

func _on_enemy_hitbox_body_exited(body):
	if (body.has_method("player")):
		in_attack_zone = false

func get_damage():
	if (in_attack_zone and global.is_attacking):
		if can_take_damage:
			health -= 20
			print("slime health:", health)
			
			$damage_cooldown.start()
			can_take_damage = false
			
			if health <= 0:
				health = 0
				self.queue_free()

func _on_damage_cooldown_timeout():
	can_take_damage = true
