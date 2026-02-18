extends Node2D

enum {SPAWN_WAVE, NORMAL, BOSS}
var state = SPAWN_WAVE

var active_wave

const wave_order = [ 18, 19, 20, 21, 22, 23]#[1,2,3,4,5,6, 7,8,9,10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
var nwaves: int
var substages = Dictionary()
var wave_index = -1
const wave_index_loop = 0
#var next_wave_number = 1
#var wave_repeats = 0

var next_wave: PackedScene

var debug_boss = false

var boss_kill = 1

const result_screen = preload('res://results_screen.tscn')
#const combo_display = preload('res://combo_display.tscn')

func clear_bullets(turn_into_items: bool, autocollect: bool):
	var will_collect
	if autocollect:
		#collect_time = -1.0
		will_collect = true
	else:
		will_collect = false
		#collect_time = global.item_collect_time
	for c in get_children():
		if c is Bullet:
			if turn_into_items:
				c.become_item(will_collect)
			c.die()
			
func clear_enemies():
	for c in get_children():
		if (c is Enemy):
			c.die_no_bonus()


func collect_items():
	for c in get_children():
		if (c is Item):
			c.start_collect()

func time_up():
	var tmp = result_screen.instantiate()
	tmp.message = 'Time up'
	$Hisami.die()
	add_child(tmp)
	
func lives_up():
	var tmp = result_screen.instantiate()
	tmp.message = 'Game Over'
	$Hisami.die()
	await get_tree().create_timer(0.35).timeout
	add_child(tmp)
	
func win():
	print('WIN')
	var tmp = result_screen.instantiate()
	tmp.message = 'Winner!'
	add_child(tmp)


func hurtflash():
	$CanvasLayer/TextureRect.visible = true
	await get_tree().create_timer(0.05).timeout
	$CanvasLayer/TextureRect.visible = false

func spawn_boss():
	trigger_boss()
	print('Spawning boss')
	var tmp = next_wave.instantiate()
	#tmp.wave_done.connect(wave_cleared)
	add_child.call_deferred(tmp)

func _ready():
	global.clear_bullets.connect(clear_bullets)
	global.clear_enemies.connect(clear_enemies)
	global.set_defaults()
	global.time_up.connect(time_up)
	global.lives_up.connect(lives_up)
	global.you_win.connect(win)
	global.spawn_boss.connect(spawn_boss)
	global.collect_items.connect(collect_items)
	nwaves = len(wave_order)
	global.play_bgm()
	$Hisami.got_hurt.connect(hurtflash)
	
	$UI.all_update()
	if debug_boss:
		#global.wave=999
		global.boss_spawn_time = 160
	spawn_next_wave()
	
func trigger_boss():
	if boss_kill == 0:
		next_wave = load('res://wave_boss.tscn')
	else:
		next_wave = load('res://wave_final_boss.tscn')
	var tmp = next_wave.instantiate()
	tmp.wave_done.connect(wave_cleared)
	state = BOSS
	
func spawn_next_wave():
	var path_to_scene: String
	var next_wave_number: int
	wave_index = wave_index + 1
	if wave_index >= nwaves:
		wave_index = wave_index_loop
		substages = Dictionary()
	
	next_wave_number = wave_order[wave_index]
	global.wave = next_wave_number
	path_to_scene = 'res://wave_' + str(global.wave).pad_zeros(2) + '.tscn'

	print(path_to_scene)
	if ResourceLoader.exists(path_to_scene):
		next_wave = load(path_to_scene)
		state = NORMAL
	else:
		trigger_boss()
		
	if not global.boss_spawned:
		if active_wave:
			# sometimes weird race condition happens
			# when old wave emits as it is free'd
			# causing two new waves to appear
			active_wave.disconnect('wave_done',wave_cleared)
		
		active_wave = next_wave.instantiate()
		active_wave.wave_done.connect(wave_cleared)
		add_child.call_deferred(active_wave)
	
func wave_cleared():
	state = SPAWN_WAVE
	# probably want to do something here?
	# kind of redundant state right now
	if not global.stop_timer:
		spawn_next_wave()
