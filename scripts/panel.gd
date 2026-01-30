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
	queue_text("Um dia ensolarado porém tempestuoso nas fronteiras da Grandline...")
	queue_text("É em dias como esses que nascem...")
	queue_text("Os heróis que vão muda nosso mundo...")
	
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
				
		State.LOAD:
			$Label.visible = false
			$VBoxContainer.visible = true
		
func change_state(next_state):
	current_state = next_state
	
	
func queue_text(next_text):
	text_queue.push_back(next_text)
	
func show_text():
	if global.ghost_apears == true:
		global.ghost_apears = false
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
