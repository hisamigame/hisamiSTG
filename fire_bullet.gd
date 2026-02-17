extends Bullet

@export var expand_duration = 0.2
@export var start_scale = 0.2

func _ready():
	var tween = self.create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	scale = Vector2.ONE * start_scale
	tween.tween_property(self,'scale',Vector2.ONE,expand_duration).set_trans(Tween.TRANS_SINE)
