extends CharacterBody2D

var enemy_attack_range = false
var enemy_attack_cooldown = true
var player_health = 100
var player_alive = true

var attack_ip = false
var attack_range_F = false
var attack_range_B = false
var attack_range_S = false


const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("idle_side")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_attack()
	attack()
	attack_dir()
	current_camera()
	update_health()
	move_and_slide()
	
	print(global.enemy_well_placed)
	# print(current_dir)
	
	
	if player_health <= 0:
		player_alive = false
		player_health = 0
		print("!you died!")
		self.queue_free()
		
		
func player_movement(delta):
	if attack_ip == false:
		if Input.is_action_pressed("ui_right"):
			current_dir = "right"
			play_anim(1)
			velocity.x = speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_left"):
			current_dir = "left"
			play_anim(1)
			velocity.x = -speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_down"):
			current_dir = "down"
			play_anim(1)
			velocity.x = 0
			velocity.y = speed
		elif Input.is_action_pressed("ui_up"):
			current_dir = "up"
			play_anim(1)
			velocity.x = 0
			velocity.y = -speed
		else:
			play_anim(0)
			velocity.x = 0
			velocity.y = 0
	
	
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if attack_ip == false:
		if dir == "right":
			anim.flip_h = false
			if movement == 1:
				anim.play("walk_side")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_side")
		if dir == "left":
			anim.flip_h = true
			if movement == 1:
				anim.play("walk_side")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_side")
		if dir == "down":
			anim.flip_h = false
			if movement == 1:
				anim.play("walk_front")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_front")
		if dir == "up":
			anim.flip_h = false
			if movement == 1:
				anim.play("walk_back")
			elif movement == 0:
				if attack_ip == false:
					anim.play("idle_back")

func player():
	pass

func enemy_attack():
	if enemy_attack_range and enemy_attack_cooldown == true:
		player_health = player_health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(player_health)
		


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true


func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("attack_side")
			if velocity.x == 100:
				velocity.x = 15
			$attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("attack_side")
			if velocity.x == -100:
				velocity.x = -15
			$attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("attack_front")
			if velocity.y == 100:
				velocity.y = 15
			$attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("attack_back")
			if velocity.y == -100:
				velocity.y = -15
			$attack_timer.start()

func _on_attack_timer_timeout() -> void:
	$attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false


func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$camp_camera.enabled = false
	elif global.current_scene == "camp":
		$world_camera.enabled = false
		$camp_camera.enabled = true
	

func update_health():
	var healthbar = $HealthBar
	healthbar.value = player_health
	
	if player_health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
		
func attack_dir():
	if current_dir == "right" and attack_range_S == true:
		global.enemy_well_placed = true
	if current_dir == "left" and attack_range_S == true:
		global.enemy_well_placed = true
	if current_dir == "down" and attack_range_B == true:
		global.enemy_well_placed = true
	if current_dir == "up" and attack_range_F == true:
		global.enemy_well_placed = true
	else:
		global.enemy_well_placed = false



func _on_regin_timer_timeout() -> void:
	if player_health < 100:
		player_health = player_health + 5
		if player_health > 100:
			player_health = 100
	if player_health <= 0:
		player_health = 0 
	


func _on_hitbox_front_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_attack_range = true
		attack_range_F = true



func _on_hitbox_front_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_attack_range = false
		attack_range_F = false



func _on_hitbox_back_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_attack_range = true
		attack_range_B = true
		

func _on_hitbox_back_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_attack_range = false
		attack_range_B = false

func _on_hitbox_side_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_attack_range = true
		attack_range_S = true


func _on_hitbox_side_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_attack_range = false
		attack_range_S = false
