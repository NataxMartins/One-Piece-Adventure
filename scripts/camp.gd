extends Node2D

func _ready() -> void:
	get_node("player")
	if global.loading == true: 
		$player.position = Vector2(global.player_load_posx, global.player_load_posy)
		global.current_scene = "camp"
		global.loading = false
		
func _process(delta: float) -> void:
	change_scenes()
	


func _on_world_exit_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = true


#		
func change_scenes():
	if global.transition_scene == true:
		if global.current_scene == "camp":
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			global.finish_changescenes()
