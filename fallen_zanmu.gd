extends AnimatedSprite2D

const big_impact = preload("res://big_impact.tscn")

var fired_position : Vector2
var velocity = Vector2.ZERO
var g = 0.5
var knockspeed = global.target_FPS * g * 0.7/2
var edge_margin = 20
var xupper = global.field_width - edge_margin
var xlower = edge_margin
var margin = 60

var rotation_speed = 0.1

func apply_knockback():
	var angle = fired_position.angle_to_point(position)
	velocity = Vector2.from_angle(angle) * knockspeed
	var tmp2 = big_impact.instantiate()
	tmp2.position = position
	add_sibling.call_deferred(tmp2)
	


func _ready() -> void:
	fired_position = global.player_position
	global.play_enemy_dead()
	apply_knockback()
	
	

func _physics_process(delta: float) -> void:
	velocity.y = velocity.y + g * delta * global.target_FPS/2
	position = position + velocity * delta * global.target_FPS
	velocity.y = velocity.y + g * delta * global.target_FPS/2
	
	rotation = rotation + rotation_speed
	
	if position.x > xupper:
		position.x = 2*xupper - position.x
		velocity.x = -velocity.x
	elif position.x < xlower:
		position.x = 2*xlower - position.x
		velocity.x = -velocity.x
