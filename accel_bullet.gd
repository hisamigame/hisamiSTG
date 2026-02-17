extends Bullet

@export var accel = 0.15
var _speed = 0.0



func _physics_process(delta: float) -> void:
	if _speed < speed:
		_speed = _speed + delta * accel* global.target_FPS/2
		position = position + delta * direction * _speed * global.target_FPS
		_speed = _speed + delta * accel* global.target_FPS/2
	else:
		position = position + delta * direction * _speed * global.target_FPS
	check_oob()
