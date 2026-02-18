extends Wave

func _ready() -> void:
	print('boss wave!')
	
	spawn_zanmu()
	
func spawn_zanmu():
	print('Zanmu spawn')
	global.stop_bgm()
	global.play_bgm_boss()
	$Zanmu.boss_dead.connect(boss_dead)
	$Zanmu.reparent.call_deferred(parent,true)
	$Zanmu.start_fight()
	
func miniboss_dead():
	# TODO this is where we could spawn in Zanmu
	pass
	
func boss_dead():
	print('wave boss dead')
	global.win()
