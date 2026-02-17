extends Sprite2D

var lifetime_frames : int= 1
var f : int = 0


func _physics_process(delta: float) -> void:
	f = f + 1
	if f>  lifetime_frames:
		queue_free()
