extends Hurtbox

var direction = Vector2.RIGHT
var speed = 20.0
var offset = Vector2(11.0,-40.0)
const clear_margin = 20.0

var fired_position: Vector2

func _ready() -> void:
	$AnimatedSprite2D.play('default')
	

func oob():
	if global_position.y < -clear_margin:
		queue_free()

func _physics_process(delta: float) -> void:
	position = position + direction * speed * delta * global.target_FPS
	oob()
	
