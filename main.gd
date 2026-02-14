extends Control

@onready var viewport = $CenterContainer/ReferenceRect/SubViewportContainer/SubViewport
@onready var current_node = $CenterContainer/ReferenceRect/SubViewportContainer/SubViewport/TitleScreen

func _ready() -> void:
	global.scene_switcher = self

func switch_scene(newScene : PackedScene):
	if current_node:
		current_node.queue_free()
	current_node = newScene.instantiate()
	viewport.add_child(current_node)
