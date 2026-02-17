extends Control

@onready var viewport = $CenterContainer/ReferenceRect/SubViewportContainer/SubViewport
var current_node

const flash = preload('res://screen_flash.tscn')

func _ready() -> void:
	current_node = viewport.get_child(0)
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
