extends Control

@onready var viewport = $CenterContainer/ReferenceRect/SubViewportContainer/SubViewport
@onready var current_node = $CenterContainer/ReferenceRect/SubViewportContainer/SubViewport/TitleScreen

const flash = preload('res://screen_flash.tscn')

func _ready() -> void:
	global.scene_switcher = self
	global.flash_screen.connect(flash_screen)

func switch_scene(newScene : PackedScene):
	if current_node:
		current_node.queue_free()
	current_node = newScene.instantiate()
	viewport.add_child(current_node)

func flash_screen(_color: Color):
	var tmp = flash.instantiate()
	#tmp.position.x = -210
	add_child(tmp)
