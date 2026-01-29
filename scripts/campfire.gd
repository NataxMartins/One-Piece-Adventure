extends CharacterBody2D
	
var player_camp = false
var game_saved = false
	
func _ready():
	$AnimatedSprite2D.play("default")
	$Save_game.visible = false
	$Saved.visible = false
	$Game_loaded.visible = false
	if global.savegame_loaded == true:
		$Game_loaded.visible = true
		$Timer_Game_loaded.start()
		global.savegame_loaded = false
		
	
func _physics_process(delta: float) -> void:
	save_game()

func save_game():
	if player_camp == true and game_saved == false:
		$Save_game.visible = true
		if Input.is_action_just_pressed("Yes"):
			global.game_has_savegame = true
			FileExport.save_game()
			$Save_game.visible = false
			$Saved.visible = true
			$Timer_Saved.start()
			print("game saved")
			game_saved = true



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_camp = true
		$Game_loaded.visible = false


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_camp = false
		$Save_game.visible = false 
		$Game_loaded.visible = false


func _on_timer_game_loaded_timeout() -> void:
	$Game_loaded.visible = false


func _on_timer_saved_timeout() -> void:
	$Saved.visible = false 
