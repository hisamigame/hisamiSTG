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
	match global.hyperlevel:
		1:
			global.flash_love_message("HEART|BREAK")
		2:
			global.flash_love_message("DOU\nHEART|BLE\nBREAK")
		3:
			global.flash_love_message("MAX \nBRE|HEART\nAK!")
func _ready():
	global.emit_clear_bullets(true, true)
	fired_position = global.player_position
	
	global.play_break()
	tween = self.create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
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
	
