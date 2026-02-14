extends Hurtbox

var direction = Vector2.RIGHT
var speed = 20.0
var offset = Vector2(11.0,0.0)
const clear_margin = 20.0

func old_oob():
	if position.x - global.camera_position.x > global.view_width + clear_margin:
		queue_free()
	elif position.x - global.camera_position.x <  -clear_margin:
		queue_free()
		
func oob():
	if position.x > global.field_width + clear_margin:
		queue_free()
	elif position.x  <  -clear_margin:
		queue_free()

func _physics_process(delta: float) -> void:
	position = position + direction * speed * delta * global.target_FPS
	oob()
	
