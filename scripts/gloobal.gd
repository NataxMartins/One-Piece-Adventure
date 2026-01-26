extends Node

var player_current_attack = false
var enemy_well_placed = false

var current_scene = "world"
var transition_scene = false

var player_exit_map_posx = 230
var player_exit_map_posy = 215
var player_start_posx = 10
var player_start_posy = 85

var game_first_loading = true


func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "camp"
		else:
			current_scene = "world"
