extends CharacterBody2D
	
var player_camp = false
var game_saved = false
	
func _ready():
	$AnimatedSprite2D.play("default")
	$Save_game.visible = false
	$Saved.visible = false
	
func _physics_process(delta: float) -> void:
	save_game()

func save_game():
	if player_camp == true and game_saved == false:
		$Save_game.visible = true
		if player_camp and Input.is_action_just_pressed("Yes"):
			global.game_has_savegame = true
			FileExport.save_game()
			$Save_game.visible = false
			$Saved.visible = true
			print("game saved")
			game_saved = true



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_camp = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_camp = false
		$Save_game.visible = false 
		
