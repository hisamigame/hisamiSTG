extends TextureRect

var can_proceed = false
@export var nextScene: PackedScene = preload("res://game.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('fire') and !event.is_echo() and can_proceed:
		global.switch_scene(nextScene)


func _on_timer_timeout() -> void:
	can_proceed = true
