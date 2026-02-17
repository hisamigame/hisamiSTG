extends ColorRect

var panels : Array
var tween : Tween

enum State {
	READING,
	FINISHED
}

var current_state : int

var current_panel : int = 0

@export var nextScene: PackedScene

func _ready() -> void:
	panels = self.get_children()
	fade_in_panel()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		if current_panel >= panels.size():
			global.switch_scene(nextScene)
		else:
			match current_state:
				State.READING:
					show_full_panel()
				State.FINISHED:
					fade_in_panel()

func fade_in_panel():
	current_state = State.READING
	tween = self.create_tween()
	tween.tween_property(panels[current_panel], "modulate", Color.WHITE, 1.0)
	tween.tween_callback(next_panel_num)

func show_full_panel():
	tween.kill()
	panels[current_panel].modulate = Color.WHITE
	next_panel_num()

func next_panel_num():
	current_state = State.FINISHED
	current_panel += 1
