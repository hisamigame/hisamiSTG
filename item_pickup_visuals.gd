extends Node2D

@export var duration = 0.25
var tween

func _ready():
	scale = Vector2.ZERO
	tween = self.create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self,'scale',Vector2.ONE,duration).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,'modulate',Color(1.0, 1.0, 1.0, 0.0),duration).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(queue_free)
