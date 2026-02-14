extends Node2D

enum {SPAWN_WAVE, NORMAL, BOSS}
var state = SPAWN_WAVE


const wave_order = [1, 2]
var nwaves: int
var substages = Dictionary()
var wave_index = -1
const wave_index_loop = 0
#var next_wave_number = 1
#var wave_repeats = 0

var next_wave: PackedScene

var debug_boss = true

var boss_kill = 1

const result_screen = preload('res://results_screen.tscn')
#const combo_display = preload('res://combo_display.tscn')

func clear_bullets(turn_into_items: bool):
	for c in get_children():
		if c is Bullet:
			if turn_into_items:
				c.become_item(global.item_collect_time)
			c.die()
			
func clear_enemies():
	for c in get_children():
		if (c is Enemy):
			c.die_no_bonus()
		

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
	tmp.wave_done.connect(wave_cleared)
	add_child.call_deferred(tmp)

func _ready():
	global.clear_bullets.connect(clear_bullets)
	global.clear_enemies.connect(clear_enemies)
	global.set_defaults()
	global.time_up.connect(time_up)
	global.lives_up.connect(lives_up)
	global.you_win.connect(win)
	global.spawn_boss.connect(spawn_boss)
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
		var tmp = next_wave.instantiate()
		tmp.wave_done.connect(wave_cleared)
		add_child.call_deferred(tmp)
	
func wave_cleared():
	state = SPAWN_WAVE
	# probably want to do something here?
	# kind of redundant state right now
	if not global.stop_timer:
		spawn_next_wave()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'bossStart':
		clear_bullets(false)
		clear_enemies()
