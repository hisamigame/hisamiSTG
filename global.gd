extends Node

var rng = RandomNumberGenerator.new()
@onready var scene_switcher: Node

const target_FPS = 60.0

const field_width : int = 540 # total width of playfield
const field_height : int = 500 # total height of playfield

signal lives_changed
signal score_changed
signal ammo_changed
signal timer_changed
signal hide_ui
signal clear_bullets(turn_into_items : bool, autocollect: bool)
signal time_up
signal lives_up
signal you_win
signal clear_enemies
signal spawn_boss
signal flash_screen(Color)
signal collect_items
signal love_message(String)
signal hyperlevel_changed
signal hypertime_changed

const ui_hide_margin = 60
#const hyper_cost = 1000
const hyper_cost = 100
const max_ammo = 100
var ui_visible = true
var stop_timer: bool
var time_left = 0.0
var second = 180
var boss_spawned=false
var boss_spawn_time = 30
var fire = false
var hyper = false
var focus = false
var hyperlevel = 0
const max_hyperlevel = 4

const item_collect_time = 0.7
var item_value = 100
var mid_item_value = 500
var big_item_value = 10000

const default_hypertime = 10.0
var hypertime = default_hypertime
var hyper_t = 0.0

var has_score_changed
var has_ammo_changed

var player_position = Vector2.ZERO

var hiscores : Array
const data_file = 'user://data.json'

var score: float
var lives: int
var wave: int
var ammo : int

func win():
	stop_timer = true
	you_win.emit()

func play_bgm():
	pass
	
func stop_bgm():
	pass
	
func play_player_dead():
	$PlayerDead.play()
	
func play_player_hurt():
	$PlayerDead.play()
	
func play_enemy_hurt():
	$EnemyHurt.play()
	
func play_enemy_dead():
	$EnemyDead.play()
	
func play_item():
	$ItemGet.play()

func flash_love_message(s: String):
	love_message.emit(s)

func default_hiscores():
	# Default hiscore list
	var default_scores = [
		[50000,'EVE'],
		[40000,'NAO'],
		[30000,'YUI'],
		[20000,'MAY'],
		[10000,'SIO'],
		[9000,'ANA'],
		[8000,'MIU'],
		[7000,'ADA'],
		[6000,'MEI'],
		[5000,'KAT']]
	return default_scores
	
func write_default_data():
	if not FileAccess.file_exists(data_file):
		print('Setting up initial save data')
		var dict = {}
		dict['hiscores'] = default_hiscores()
		var file = FileAccess.open(data_file, FileAccess.WRITE)
		file.store_string(JSON.stringify(dict))
		file.close()
		
func save_data():
	print('Saving data...')
	var dict = {}
	dict['hiscores'] = hiscores
	var file = FileAccess.open(data_file, FileAccess.WRITE)
	file.store_string(JSON.stringify(dict))
	file.close()
	print('Finished saving!')

func load_data():
	if !FileAccess.file_exists(data_file):
		write_default_data()
	# THIS IS NOT SAFE
	# IF THE PLAYER HAS EDITED OR CORRUPTED THEIR FILE
	var file = FileAccess.open(data_file, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var dict = JSON.parse_string(content)
	hiscores = dict['hiscores']
	
func set_defaults():
	global.score = 0.0
	global.lives = 1
	global.wave = 0
	global.ammo = 0
	global.time_left = 180.0
	global.second = 180
	global.stop_timer = false
	global.boss_spawned = false
	
func set_lives(val):
	global.lives = val
	if val < 0:
		lives_up.emit()
		stop_timer = true
	else:
		lives_changed.emit()
	
func set_score(val):
	global.score = val
	#score_changed.emit()
	has_score_changed = true
	
func set_ammo(val):
	global.ammo = min(val,max_ammo)
	#ammo_changed.emit()
	has_ammo_changed = true
	
func set_hyperlevel(val):
	global.hyperlevel = min(val, global.max_hyperlevel)
	if global.hyperlevel == 1:
		Item.reset_n_items()
	hyperlevel_changed.emit()
	
func emit_clear_bullets(turn_into_items: bool, autocollect: bool):
	clear_bullets.emit(turn_into_items, autocollect)
	
func emit_clear_enemies():
	clear_enemies.emit()
	
func emit_collect_items():
	collect_items.emit()


func screen_flash():
	flash_screen.emit(Color("ff8cceff"))

var verticalMovementPressOrder = [Vector2.ZERO] 
var horizontalMovementPressOrder = [Vector2.ZERO]

func switch_scene(newScene: PackedScene):
	scene_switcher.switch_scene(newScene)

func process_direction_input_buffer(event):
	# Input buffer to resolve opposing cardinal directions etc.
	# Order which inputs are pressed is stored and
	# the latest pressed direction takes priority.
	# The resulting direction is obtained by
	# global.get_movement_direction().
	if event.is_action_pressed("left"):
		global.horizontalMovementPressOrder.erase(Vector2.LEFT)
		global.horizontalMovementPressOrder.append(Vector2.LEFT)
	if event.is_action_released("left"):
		global.horizontalMovementPressOrder.erase(Vector2.LEFT)
	
	if event.is_action_pressed("right"):
		global.horizontalMovementPressOrder.erase(Vector2.RIGHT)
		global.horizontalMovementPressOrder.append(Vector2.RIGHT)
	if event.is_action_released("right"):
		global.horizontalMovementPressOrder.erase(Vector2.RIGHT)
		
	# Vertical movement
	if event.is_action_pressed("up"):
		global.verticalMovementPressOrder.erase(Vector2.UP)
		global.verticalMovementPressOrder.append(Vector2.UP)
	if event.is_action_released("up"):
		global.verticalMovementPressOrder.erase(Vector2.UP)
		
	if event.is_action_pressed("down"):
		global.verticalMovementPressOrder.erase(Vector2.DOWN)
		global.verticalMovementPressOrder.append(Vector2.DOWN)
	if event.is_action_released("down"):
		global.verticalMovementPressOrder.erase(Vector2.DOWN)
		
func process_focus(event):
	if event.is_action_pressed('focus'):
		focus = true
	elif event.is_action_released('focus'):
		focus = false
		
func process_fire(event):
	if event.is_action_pressed('fire'):
		fire = true
	elif event.is_action_released('fire'):
		fire = false
		
func process_hyper(event):
	if event.is_action_pressed('hyper'):
		hyper = true
	elif event.is_action_released('hyper'):
		hyper = false
		
func _input(event):		
	process_direction_input_buffer(event)
	process_focus(event)
	process_fire(event)
	process_hyper(event)

func get_movement_direction():
	# get movement direction from movement input buffers
	var dir: Vector2 = (global.verticalMovementPressOrder[-1] + global.horizontalMovementPressOrder[-1]).normalized()
	return dir



func _physics_process(delta: float) -> void:
	
	if not stop_timer:
		
		time_left = time_left - delta
		var new_second = ceili(time_left)
		
		if time_left < boss_spawn_time and !boss_spawned:
			spawn_boss.emit()
			boss_spawned = true
		
		if time_left < -1.0:
			# we give the player 1 extra second
			# because it's tense to have the timer show 0
			time_up.emit()
			stop_timer = true
		elif new_second < second:
			second = new_second
			timer_changed.emit()
			
		if has_score_changed:
			score_changed.emit()
			has_score_changed = false
		if has_ammo_changed:
			ammo_changed.emit()
			has_ammo_changed = false
			
		if hyper_t > 0:
			hypertime_changed.emit()
			
func set_player_position(v):
	global.player_position = v
	if (global.player_position.y < ui_hide_margin) and ui_visible:
		hide_ui.emit(true)
		ui_visible = false
	elif (global.player_position.y > ui_hide_margin) and not ui_visible:
		hide_ui.emit(false)
		ui_visible = true
		
func _ready() -> void:
	load_data()
	
