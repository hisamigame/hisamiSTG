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
var precision = 100.0
var bullet_interval = 0.3

var phase_done = false
var tween
var bullet_tween
var patrol_tween

func _ready():
	original_position = position
	
	
func end_phase_criteria(node):
	if node.position.distance_squared_to(target_position) < precision:
		return true

func spawn_bullet(node : Node2D):
	var tmp = needle_bullet.instantiate()
	tmp.position = node.position
	node.add_sibling(tmp)
	
func start_bullet_spawn():
	bullet_tween.play()
	
func stop_bullet_spawn():
	bullet_tween.stop()
	
func start_patrol():
	patrol_tween.play()
	
func stop_patrol():
	patrol_tween.stop()

func run(node: Node2D):
	tween = self.create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	bullet_tween = self.create_tween()
	bullet_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	bullet_tween.set_loops()
	
	patrol_tween = self.create_tween()
	patrol_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	patrol_tween.set_loops()
	
	patrol_tween.tween_property(node, 'position',target_position2, patrol_time).set_trans(Tween.TRANS_SINE)
	patrol_tween.tween_property(node, 'position',target_position1, patrol_time).set_trans(Tween.TRANS_SINE)
	
	bullet_tween.tween_callback(spawn_bullet.bind(node))
	bullet_tween.tween_interval(bullet_interval)
	
	tween.tween_callback(stop_bullet_spawn)
	tween.tween_callback(stop_patrol)
	tween.tween_property(node, 'position',target_position, patrol_time/2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(start_bullet_spawn)
	tween.tween_property(node, 'position',target_position1, patrol_time/2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(start_patrol)
