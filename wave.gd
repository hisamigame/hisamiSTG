extends Node2D
class_name Wave

var living_enemies = []
signal wave_done

@export var wave_timer = 10.0

@onready var parent = get_parent()

var can_emit = false

func _ready():
	start_wave()
	$Timer.start(wave_timer)
	
func spawn_enemy(c):
	#var original_x = c.position.x
	#var original_process = c.process_mode
	#c.position.x = -666
	#c.process_mode = PROCESS_MODE_DISABLED
	if c.optional:
		# If optional, we already have unchecked it in the list
		# used to see if all enemies in the wave are dead
		living_enemies.append(false)
	else:
		living_enemies.append(true)
	c.reparent.call_deferred(parent,true)
	c.died.connect(enemy_died)
	#await get_tree().create_timer(c.spawn_delay).timeout
	#c.position.x = original_x
	#c.process_mode = original_process

func start_wave():
	var i : int = 0
	for c in get_children():
		if c is Enemy: # redudant check probably
			c.enemy_index = i
			spawn_enemy(c)
			i = i + 1
	can_emit = true

func enemy_died(i):
	living_enemies[i] = false
	var sum =0
	for le in living_enemies:
		sum = sum + int(le)
	if sum == 0:
		do_wave_done()

func do_wave_done():
	wave_done.emit()
	queue_free()
	

func _on_timer_timeout() -> void:
	do_wave_done()
