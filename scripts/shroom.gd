extends CharacterBody2D

var attack_range = false
var collect = false 

func shroom():
	pass


func _physics_process(delta: float) -> void:
	if attack_range == true and global.player_current_attack == true and global.shroom_well_placed == true:
		$AnimatedSprite2D.play("default")
		$Timer.start()
	if collect == true:
		global.shroom_chunks = global.shroom_chunks + 3
		self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		attack_range = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
			attack_range = false

func _on_timer_timeout() -> void:
	collect = true
