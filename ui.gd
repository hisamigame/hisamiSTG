extends Control

func _ready() -> void:
	global.lives_changed.connect(update_lives)
	global.score_changed.connect(update_score)
	global.ammo_changed.connect(update_ammo)
	global.hide_ui.connect(hide_self)
	global.timer_changed.connect(update_timer)
	
	$SubViewport/AmmoBar.max_value = global.max_ammo
	

func all_update():
	# called at the start
	update_lives()
	update_score()
	update_ammo()
	update_timer()


func hide_self(v):
	$SubViewport.visible = !v

func update_timer():
	$SubViewport/TimeDisplay/Label.text = str(global.second)


func update_lives():
	$SubViewport/Lives/Label.text = 'x' + str(global.lives)

func update_score():
	$SubViewport/Score.text = str(int(round(global.score)))
	
func update_ammo():
	$SubViewport/AmmoBar.value = global.ammo
