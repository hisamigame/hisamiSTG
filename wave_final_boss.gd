extends Wave

func _ready() -> void:
	print('Zanmu!')
	$Zanmu.boss_dead.connect(boss_dead)
	# $Zanmu.position = 
	#var parent = get_parent()
	$Zanmu.reparent.call_deferred(parent,true)
	
func boss_dead():
	print('wave boss dead')
	global.win()
