extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null
var random_dir = Vector2.ZERO
var idle = true
var idle_speed = 20
var idle_walking = false
var idle_stop = false

var health = 100
var player_attack_range = false
var can_take_damage = true


func _physics_process(delta: float) -> void:
	deal_with_damage()	
	move_and_slide()
	random_direction()
	idle_walk()
	idle_animation()
	
	
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
	if idle == true and idle_stop == false:
		velocity = random_dir * idle_speed
	else:
		velocity = Vector2.ZERO
	
func idle_animation():
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
		if player_chase:
			position += (player.position - position) / speed

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
	if player_attack_range and global.player_current_attack == true:
		if can_take_damage == true:
			health = health -40
			$damage_timer.start()
			can_take_damage = false
			print(health)
			if health <= 0:
				self.queue_free()


func _on_damage_timer_timeout() -> void:
	can_take_damage = true

func _on_direction_timer_timeout() -> void:
	idle_walking = false


func _on_walk_timer_timeout() -> void:
	idle_stop = true
