extends Node2D

var fired_position : Vector2
var knockback_cooldown = 0.6
var can_knockback = false
var velocity = Vector2.ZERO
var g = 0.5
var knockspeed = global.target_FPS * g * knockback_cooldown/2
var edge_margin = 20
var xupper = global.field_width - edge_margin
var xlower = edge_margin

@export var bounce_limit = 5
var n_bounce = 0

var t = 0

const death_effect = preload('res://death_effect.tscn')
const item = preload('res://item.tscn')

func spawn_item(spawn_position):
	var tmp = item.instantiate()
	tmp.position = spawn_position
	add_sibling.call_deferred(tmp)

func die():
	var tmp = death_effect.instantiate()
	tmp.position = position
	tmp.radius=50
	add_sibling.call_deferred(tmp)
	global.play_enemy_dead()
	for i in 16:
		spawn_item(position)
	queue_free()

func apply_knockback():
	n_bounce = n_bounce + 1
	if n_bounce >= bounce_limit:
		die()
	else:
		for i in 8:
			spawn_item(position)
		var angle = fired_position.angle_to_point(position)
		velocity = Vector2.from_angle(angle) * knockspeed
	

func set_flavor(flavorname: String):
	$AnimatedSprite2D.play(flavorname)

func _ready() -> void:
	apply_knockback()
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if can_knockback:
		global.play_enemy_dead()
		fired_position = area.fired_position
		apply_knockback()
		can_knockback = false
	spawn_item(area.position)
		

func _physics_process(delta: float) -> void:
	t = t + delta
	if t > knockback_cooldown:
		t = 0
		can_knockback = true
	velocity.y = velocity.y + g * delta * global.target_FPS/2
	position = position + velocity * delta * global.target_FPS
	velocity.y = velocity.y + g * delta * global.target_FPS/2
	
	if position.x > xupper:
		position.x = 2*xupper - position.x
		velocity.x = -velocity.x
	elif position.x < xlower:
		position.x = 2*xlower - position.x
		velocity.x = -velocity.x
		
