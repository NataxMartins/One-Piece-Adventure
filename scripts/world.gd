extends Node2D

func _ready() -> void:
	if global.game_first_loading == true:
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
	else:
		$player.position.x = global.player_exit_map_posx
		$player.position.y = global.player_exit_map_posy


func _process(delta: float) -> void:
	change_scene()

func _on_camp_exit_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true


		
func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/camp.tscn")
			global.game_first_loading = false
			global.finish_changescenes()
	
