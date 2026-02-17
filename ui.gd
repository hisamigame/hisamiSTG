extends Control

const love_text = preload("res://love_text.tscn")

var past_lives = global.lives

func show_love_message(s: String):
	var tmp = love_text.instantiate()
	var ss = s.split("|")
	tmp.textleft = ss[0]
	tmp.textright = ss[1]
	add_child(tmp)

func change_hyperlevel():
	if global.hyperlevel == 0:
		$SubViewport/HyperLevelIndicator.unreveal()
	else:
		$SubViewport/HyperLevelIndicator.reveal()
	$SubViewport/HyperLevelIndicator.set_level(global.hyperlevel)
	
func change_hypertime():
	$SubViewport/HyperLevelIndicator.set_time(global.hyper_t)


func _ready() -> void:
	global.lives_changed.connect(update_lives)
	global.score_changed.connect(update_score)
	global.ammo_changed.connect(update_ammo)
	global.hide_ui.connect(hide_self)
	global.timer_changed.connect(update_timer)
	global.love_message.connect(show_love_message)
	global.hyperlevel_changed.connect(change_hyperlevel)
	global.hypertime_changed.connect(change_hypertime)	
	

func all_update():
	# called at the start
	update_lives()
	update_score()
	update_ammo()
	update_timer()


func revert_life_icon():
	$SubViewport/Lives/LifeIcon.play('default')
	
func ouch_life_icon():
	$SubViewport/Lives/LifeIcon.play('ouch')

func hide_self(v):
	$SubViewport.visible = !v

func update_timer():
	$SubViewport/TimeDisplay/Label.text = str(global.second)

func update_lives():
	if global.lives < past_lives:
		var tween = self.create_tween()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_callback(ouch_life_icon)
		tween.tween_interval(2.5)
		tween.tween_callback(revert_life_icon)
	past_lives = global.lives
	if global.lives >= 0:
		$SubViewport/Lives/Label.text = 'x' + str(global.lives)
	else:
		$SubViewport/Lives/Label.add_theme_font_size_override("font_size",32)
		$SubViewport/Lives/Label.text = 'GAME\nOVER'

func update_score():
	$SubViewport/Score.text = str(int(round(global.score)))
	
func update_ammo():
	$SubViewport/AmmoBar.value = global.ammo
