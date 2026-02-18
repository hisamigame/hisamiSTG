extends Bullet

var duration = 0.2

func _ready():
	var tween = self.create_tween()
	$AnimatedSprite2D.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property($AnimatedSprite2D,'self_modulate',Color(1.0, 1.0, 1.0, 1.0), duration).set_trans(Tween.TRANS_SINE)
	super._ready()
