extends Hurtbox

var direction = Vector2.RIGHT
var speed = 20.0
var offset = Vector2(11.0,0.0)
const clear_margin = 20.0


func oob():
	if position.y < -clear_margin:
		queue_free()

func _physics_process(delta: float) -> void:
	position = position + direction * speed * delta * global.target_FPS
	oob()
	
