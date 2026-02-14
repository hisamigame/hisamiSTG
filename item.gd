extends AnimatedSprite2D

enum {SPAWN, WAIT, SUCK}
var state = SPAWN
var direction : Vector2
var speed = 10.0
var threshold = 20.0*2

var value = global.item_value
var time = 0.0
var spawn_time = 0.5
var jump_height = 15.0
var initial_y : float
var collect_time = -1
var combo_time = 0.15

func die():
	queue_free()
	
func _ready():
	initial_y = position.y
	if collect_time > 0.0:
		$Timer.start(collect_time)

func start_collect():
	state = SUCK
	
func collect():
	global.set_score(global.score + value)
	global.combo = global.combo + 1
	global.combo_timer = combo_time
	global.play_item()
	die()

func _physics_process(delta: float) -> void:
	match state:
		SPAWN:
			time = time + delta
			position.y = initial_y - jump_height * (1 - (1 - time/spawn_time)**2)
			if time > spawn_time:
				state = WAIT
		WAIT:
			pass
		SUCK:
			direction = position.direction_to(global.player_position)
			position = position + speed * delta * global.target_FPS * direction
			if position.distance_squared_to(global.player_position) < threshold:
				collect()


func _on_timer_timeout() -> void:
	start_collect()
