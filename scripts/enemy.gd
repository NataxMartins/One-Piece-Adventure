extends CharacterBody2D

var speed = 50
var player_chase = false
var vector_chase = Vector2.ZERO
var player = null
var random_dir = Vector2.ZERO
var idle = true
var idle_speed = 20
var idle_walking = false
var idle_stop = false

var enemy_alive = true
var health = 100
var player_attack_range = false
var can_take_damage = true


func _physics_process(delta: float) -> void:
	deal_with_damage()	
	move_and_slide()
	random_direction()
	idle_walk()
	idle_animation()
	chasing_player()
	chasing_animation()
	
	
func random_direction():
	if idle == true and idle_walking == false:
		var random_waiting = randf_range(1, 3)
		$direction_timer.wait_time = random_waiting + randf_range(1, 3)
		$walk_timer.wait_time = random_waiting
		$direction_timer.start()
		$walk_timer.start()
		idle_walking = true
		idle_stop = false
		
		random_dir = Vector2(randf_range(-10, 10), randf_range(-10, 10)).normalized()
		
func idle_walk():
	if enemy_alive:
		if idle == true and idle_stop == false:
			velocity = random_dir * idle_speed
		else:
			velocity = Vector2.ZERO
		
func idle_animation():
	if player_chase == false and enemy_alive:
		if abs(random_dir.x) > abs(random_dir.y):
			$AnimatedSprite2D.play("idle_side")
			if random_dir.x < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
		if abs(random_dir.y) > abs(random_dir.x):
			if random_dir.y < 0:
				$AnimatedSprite2D.play("idle_back")		
			else: 
				$AnimatedSprite2D.play("idle_front")		
		
func chasing_player():
		if player_chase and enemy_alive:
			var distance = position.distance_to(player.position)
			if distance > 10:
				vector_chase = (player.position - position).normalized()
				velocity = vector_chase * speed

func chasing_animation():
		if player_chase == true:
			if abs(vector_chase.x) > abs(vector_chase.y):
				if $AnimatedSprite2D.animation != "walk_side":
					$AnimatedSprite2D.play("walk_side")
					if vector_chase.x < 0:
						$AnimatedSprite2D.flip_h = true
					else:
						$AnimatedSprite2D.flip_h = false
			elif abs(vector_chase.x) < abs(vector_chase.y):
				if vector_chase.y > 0:
					if $AnimatedSprite2D.animation	 != "walk_front":
						$AnimatedSprite2D.play("walk_front")
					else:
						if $AnimatedSprite2D.animation != ("walk_back"):
							$AnimatedSprite2D.play("walk_back")
					
	

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	
func enemy():
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_attack_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_attack_range = false


func deal_with_damage():
	if enemy_alive == true:
		if player_attack_range and global.player_current_attack == true:
			if can_take_damage == true:
				health = health -40
				$damage_timer.start()
				can_take_damage = false
				print("Enemy health: ", health)
				if health <= 0:
					$AnimatedSprite2D.play("death")
					$death_timer.start()
					enemy_alive = false


func _on_damage_timer_timeout() -> void:
	can_take_damage = true

func _on_direction_timer_timeout() -> void:
	idle_walking = false


func _on_walk_timer_timeout() -> void:
	idle_stop = true


func _on_death_timer_timeout() -> void:
	self.queue_free()
