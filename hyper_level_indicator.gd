extends Control

func set_time(t):
	var text = "%.2f" % t
	$Countdown.text = text
	$BGCountdown.text = text
	
func set_level(t):
	var text
	if t == 4:
		text = 'MAX!!'
	else:
		text = str(t)
	$Level.text = text
	$BGLevel.text = text
	

func reveal():
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

func unreveal():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	if global.hyperlevel < 1:
		unreveal()
