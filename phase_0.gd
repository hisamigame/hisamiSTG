extends Node

var original_position : Vector2
var position : Vector2

const needle_bullet = preload('res://needle_bullet.tscn')

@export var target_position = Vector2(global.field_width/2.0, global.field_height/3.0)
@export var target_position1 = Vector2(global.field_width * 0.97, global.field_height/3.0)
@export var target_position2 = Vector2(global.field_width * 0.03, global.field_height/3.0)
@export var enter_time = 4.0
@export var patrol_time = 2.0
@export var transition_x = Tween.TRANS_SINE
@export var transition_y = Tween.TRANS_QUAD
@export var bullet_spread = 40.0
@export var bullet_interval = 0.3
@export var nbullets = 4
@export var bob_time = patrol_time/1.61803398875
@export var bob_amp = 100.0

var phase_done = false
var tween
var bullet_tween
var patrol_tween
var bob_tween

func _ready():
	original_position = position
	

func spawn_bullet(node : Node2D):
	for i in nbullets:
		var tmp = needle_bullet.instantiate()
		tmp.position = node.position
		tmp.position.x = tmp.position.x + global.rng.randf_range(-bullet_spread,bullet_spread)
		tmp.position.y = tmp.position.y + global.rng.randf_range(-bullet_spread,bullet_spread)
		node.add_sibling(tmp)
	
func start_bullet_spawn():
	bullet_tween.play()
	
func stop_bullet_spawn():
	bullet_tween.stop()
	
func start_patrol():
	patrol_tween.play()
	
func stop_patrol():
	patrol_tween.stop()
	
func start_bob():
	bob_tween.play()
	
func stop_bob():
	bob_tween.stop()
	
	
func increase_nbullet():
	nbullets = nbullets + 1
	
func run(node: Node2D):
	tween = self.create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	bullet_tween = self.create_tween()
	bullet_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	bullet_tween.set_loops()
	
	patrol_tween = self.create_tween()
	patrol_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	patrol_tween.set_loops()
	
	bob_tween = self.create_tween()
	bob_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	bob_tween.set_loops()
	
	bob_tween.tween_property(node, 'position:y',target_position2.y - bob_amp, bob_time).set_trans(Tween.TRANS_SINE)
	bob_tween.tween_property(node, 'position:y',target_position2.y, bob_time).set_trans(Tween.TRANS_SINE)

	
	patrol_tween.tween_property(node, 'position:x',target_position2.x, patrol_time).set_trans(Tween.TRANS_SINE)
	patrol_tween.tween_property(node, 'position:x',target_position1.x, patrol_time).set_trans(Tween.TRANS_SINE)
	patrol_tween.tween_callback(increase_nbullet)
	
	bullet_tween.tween_callback(spawn_bullet.bind(node))
	bullet_tween.tween_interval(bullet_interval)
	
	tween.tween_callback(stop_bullet_spawn)
	tween.tween_callback(stop_patrol)
	tween.tween_callback(stop_bob)
	tween.tween_property(node, 'position',target_position, patrol_time/2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(start_bullet_spawn)
	tween.tween_property(node, 'position',target_position1, patrol_time/2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(start_patrol)
	tween.tween_callback(start_bob)
