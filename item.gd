extends Area2D
class_name Item

enum {SPAWN, WAIT, SUCK}
var state = SPAWN
var direction : Vector2
var speed = 10.0
var threshold = 20.0*2

var value = global.item_value
var time = 0.0
var spawn_time = 0.25
var jump_distance = 25.0
var initial_position : Vector2
var collect_time = -1
var combo_time = 0.15
var fall_speed = 4.0
var jump_direction = Vector2.UP

var will_collect = false

func die():
	queue_free()
	
func _ready():
	initial_position = position
	jump_direction = Vector2.from_angle(global.rng.randf_range(0,-PI))
	if collect_time > 0.0:
		$Timer.start(collect_time)

func start_collect():
	if state == WAIT:
		state = SUCK
	elif state == SPAWN:
		will_collect = true
func collect():
	global.set_score(global.score + value)
	#global.combo = global.combo + 1
	#global.combo_timer = combo_time
	global.set_ammo(global.ammo + 1)
	global.play_item()
	die()

func _physics_process(delta: float) -> void:
	match state:
		SPAWN:
			time = time + delta
			position = initial_position + jump_distance * jump_direction *(2*(time/spawn_time) - (time/spawn_time)**2)
			if time > spawn_time:
				if will_collect:
					state = SUCK
				else:
					state = WAIT
		WAIT:
			position.y = position.y + fall_speed * delta * global.target_FPS
		SUCK:
			direction = position.direction_to(global.player_position)
			position = position + speed * delta * global.target_FPS * direction
			if position.distance_squared_to(global.player_position) < threshold:
				collect()

func _on_area_entered(_area: Area2D) -> void:
	start_collect()
