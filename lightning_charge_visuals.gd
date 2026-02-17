extends Sprite2D

@export var duration = 0.2
var tween

func _ready():
	tween = self.create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self,'scale',Vector2.ZERO,duration).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(queue_free)
