extends Control

func _ready() -> void:
	get_node("menu/button_container/button_new_game").grab_focus()
	FileExport.pre_load()


func _on_button_new_game_pressed() -> void:
	$start.start()


func _on_button_load_game_pressed() -> void:
	$load.start()

func _on_button_quit_pressed() -> void:
	$quit.start()




func _on_start_timeout() -> void:
	FileExport.new_game()
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_load_timeout() -> void:
	if global.game_has_savegame == true:
		global.loading = true
		FileExport.load_game()
		get_tree().change_scene_to_file("res://scenes/camp.tscn")
		global.player_alive = true
		global.game_first_loading = false
		global.finish_changescenes()
	else:
		FileExport.new_game()
		get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_quit_timeout() -> void:
	get_tree().quit()
