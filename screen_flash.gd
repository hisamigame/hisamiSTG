extends TextureRect

var duration = 0.35
var tween

func _ready():
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	tween = self.create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self,'modulate',Color(1.0, 1.0, 1.0, 1.0),duration/2).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,'modulate',Color(1.0, 1.0, 1.0, 0.0),duration/2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(queue_free)
