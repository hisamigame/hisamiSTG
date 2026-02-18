extends TextureRect


@export var nextScene: PackedScene = preload("res://hiscore_screen.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		global.switch_scene(nextScene)
