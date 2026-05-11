extends Area2D

var move = true
var direction : Vector2
var active = true
@export var speed = 1.0
var default_speed = 1.0
var bouncing = true
var time = 0.0
var will_stop_bouncing = false
var bounce_time = 180.0
var inactive_time = 0.5
var collectible = false

enum {HALF, FULL}
var flavor = HALF
var ammo_value: int

const screen_margin = 16

var angle_min = -PI
var angle_max = 0.0

var initial_y = 0.0

func _ready() -> void:
	initial_y = position.y
	var angle = global.rng.randf_range(angle_min, angle_max)
	direction = Vector2.from_angle(angle)
	match flavor:
		HALF:
			@warning_ignore("integer_division")
			ammo_value = global.max_ammo/2
			$AnimatedSprite2D.play('half')
		FULL:
			ammo_value = global.max_ammo
			$AnimatedSprite2D.play('full')

func _on_area_entered(_area: Area2D) -> void:
	#var tmp = item_grab_scene.instantiate()
	#tmp.position = position
	#tmp.item_name = item_name
	#add_sibling(tmp)
	if collectible:
		global.play_refill_item()
		global.set_ammo(global.ammo + ammo_value)
		queue_free()

func _physics_process(delta: float) -> void:
	if move:
		if active:
			time = time + delta
			if time > bounce_time:
				# switch to not bouncing the next bounce
				
				will_stop_bouncing = true
			if time > inactive_time:
				collectible = true
				
			position = position + direction * speed * delta * global.target_FPS
			if bouncing:
				if (position.y < screen_margin and direction.y < 0) or (position.y > global.field_height - screen_margin and direction.y>0):
					direction.y = -direction.y
					if will_stop_bouncing:
						bouncing = false
						modulate = Color(Color.WHITE, 0.75)
				if (position.x < screen_margin and direction.x <0) or (position.x > global.field_width - screen_margin and direction.x>0):
					direction.x = -direction.x
					if will_stop_bouncing:
						bouncing = false
						modulate = Color(Color.WHITE, 0.75)
			else:
				if global_position.x < -10 or global_position.y < -10 or global_position.x > global.field_width + 10 or global_position.y > global.field_height + 10:
					queue_free()
	else:
		time = time + delta
		global_position.y = initial_y + 4.0*sin(time)
		if global_position.x < -10:
			queue_free()

func proximity():
	speed = default_speed * 0.25
	
func unproximity():
	speed = default_speed
