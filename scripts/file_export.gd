extends Node

const PATH = "user://gamesave.tres"
var data : Data

func _init() -> void:
	new_game()
	
func new_game():
	data = Data.new()
	
func save_game():
	data.player_exp = global.player_exp
	data.player_lvl = global.player_lvl
	data.shroom_chunks = global.shroom_chunks
	data.game_has_savegame = global.game_has_savegame
	ResourceSaver.save(data, PATH)
	print("Game Saved")
	
func load_game():
	if ResourceLoader.exists(PATH):
		data = ResourceLoader.load(PATH)
		global.player_exp = data.player_exp
		global.player_lvl = data.player_lvl
		global.shroom_chunks = data.shroom_chunks
		global.game_has_savegame = data.game_has_savegame

func pre_load():
	if ResourceLoader.exists(PATH):
		data = ResourceLoader.load(PATH)
		global.game_has_savegame = data.game_has_savegame

	
