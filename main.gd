extends Control

@onready var viewport = $CenterContainer/ReferenceRect/SubViewportContainer/SubViewport
var current_node

const flash = preload('res://screen_flash.tscn')

var tween

func _ready() -> void:
	current_node = viewport.get_child(0)
	global.scene_switcher = self
	global.flash_screen.connect(flash_screen)

func switch_scene(newScene : PackedScene):
	tween = self.create_tween()
	tween.tween_property($FadeStuff, "modulate", Color.BLACK, 0.3)
	tween.tween_callback(switch_scene_real.bind(newScene))

func flash_screen(_color: Color):
	var tmp = flash.instantiate()
	#tmp.position.x = -210
	add_child(tmp)

func switch_scene_real(newScene : PackedScene):
	kill_tween()
	
	if current_node:
		current_node.queue_free()
	current_node = newScene.instantiate()
	viewport.add_child(current_node)
	
	tween = self.create_tween()
	tween.tween_property($FadeStuff, "modulate", Color.TRANSPARENT, 0.3)
	tween.tween_callback(kill_tween)

func kill_tween():
	tween.kill()
