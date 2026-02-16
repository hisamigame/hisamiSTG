extends Control

var _value = 0
var _max_value = 100
var flash_duration = 0.1

const full_love_material = preload('res://full_love_shader.tres')

var tween

var value: int:
	get:
		return _value
	set(v):
		if v == _max_value and _value != _max_value:
			to_max()
		elif v != _max_value and _value == _max_value:
			from_max()
		_value = v
		$Progress.value = v
		
func set_progress_material():
	$Progress.material = full_love_material
		
func to_max():
	print('to max')
	$Prompt.visible = true
	
	var my_tween = self.create_tween()
	my_tween.tween_property($FlashRect,'modulate',Color(1.0, 1.0, 1.0, 1.0),flash_duration).set_trans(Tween.TRANS_SINE)
	my_tween.tween_callback(set_progress_material)
	my_tween.tween_property($FlashRect,'modulate',Color(1.0, 1.0, 1.0, 0.0),flash_duration).set_trans(Tween.TRANS_SINE)
	tween.play()

func from_max():
	$Prompt.visible = false
	$Progress.material = null
	tween.stop()
		
var max_value: int:
	get:
		return _max_value
	set(v):
		_max_value = v
		$Progress.max_value = v

func _ready() -> void:
	$Progress.size.y = $Frame.size.y
	$Progress.size.x = $Frame.size.x
	$Progress.material = null
	$Prompt.visible = false
	max_value = global.max_ammo
	
	tween = self.create_tween().set_loops()
	tween.tween_property($Prompt,'position',Vector2(0.0,-1.0),0.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Prompt,'position',Vector2(0.0,0.0),0.1).set_trans(Tween.TRANS_SINE)
	tween.stop()
