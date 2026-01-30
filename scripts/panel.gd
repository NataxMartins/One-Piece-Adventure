extends Panel

var text_queue = []
var text_velo = 10
enum State {
	READY,
	READING,
	FINISHED,
	LOAD
}

var current_state = State.READY
var tween : Tween = null 

func _ready() -> void:
	$Label.visible = false
	$VBoxContainer.visible = false
	change_state(State.READY)
	queue_text("Nem sempre é fácil bancar o herói...")
	queue_text("Suas escolhar sempre terão consequências...")
	queue_text("Pronto para encará-las novamente?...")
	
func _process(delta: float) -> void:
	match current_state:
		State.READY:
			if text_queue:
				show_text()
		
		State.READING:
			if Input.is_action_just_pressed("attack"):
				$Label.visible_ratio = 1
				if tween:
					tween.kill()
					change_state(State.FINISHED)
		
		State.FINISHED:
			if text_queue and Input.is_action_just_pressed("attack"):
				change_state(State.READY)
			elif not text_queue and Input.is_action_just_pressed("attack"):
				change_state(State.LOAD)
				global.ghost_apears = false
				
		State.LOAD:
			$Label.visible = false
			$VBoxContainer.visible = true
		
func change_state(next_state):
	current_state = next_state
	
	
func queue_text(next_text):
	text_queue.push_back(next_text)
	
func show_text():
	if global.ghost_apears == true:
		var next_text = text_queue.pop_front()
		change_state(State.READING)
		$Label.text = next_text
		$Label.visible = true
		$Label.visible_ratio = 0.0
		var duration = float(len(next_text) / text_velo)
		tween = get_tree().create_tween()
		tween.tween_property($Label, "visible_ratio", 1.0, duration)
		tween.tween_callback(Callable(self, "on_text_end"))
		
func on_text_end():
	change_state(State.FINISHED)


func _on_quit_button_up() -> void:
	get_tree().quit()

 
func _on_load_button_up() -> void:
	if global.game_has_savegame == true:
		global.loading = true
		FileExport.load_game()
		get_tree().change_scene_to_file("res://scenes/camp.tscn")
		global.player_alive = true
		global.game_first_loading = false
		global.savegame_loaded = true
		global.finish_changescenes()
	else:
		FileExport.new_game()
		get_tree().change_scene_to_file("res://scenes/world.tscn")
