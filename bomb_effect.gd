extends Hurtbox
var fired_position

const subvisual = preload("res://bomb_visuals.tscn")
var player : Node

var tween

func create_visual():
	var tmp = subvisual.instantiate()
	tmp.duration = 0.8
	#tmp.global_position = global.player_position
	player.add_child(tmp)

func flash_screen():
	global.screen_flash()
	
func collect_items():
	global.emit_collect_items()
	
func flash_love_text():
	global.flash_love_message("OVER|LOVE")

func _ready():
	global.emit_clear_bullets(true, true)
	fired_position = global.player_position
	
	tween = self.create_tween()
	tween.tween_callback(create_visual)
	tween.tween_callback(collect_items)
	tween.tween_interval(0.2)
	tween.tween_callback(create_visual)
	tween.tween_callback(collect_items)
	tween.tween_interval(0.2)
	tween.tween_callback(create_visual)
	tween.tween_callback(collect_items)
	#tween.tween_interval(0.2)
	#tween.tween_callback(create_visual)
	#tween.tween_interval(0.2)
	#tween.tween_callback(create_visual)
	#tween.tween_interval(0.2)
	#tween.tween_callback(create_visual)
	tween.tween_interval(0.2)
	tween.tween_interval(0.6 - 0.35/2)
	tween.tween_callback(flash_love_text)
	tween.tween_callback(flash_screen)
	tween.tween_interval(0.35/2)
	tween.tween_callback(collect_items)
	tween.tween_callback(queue_free)
	
