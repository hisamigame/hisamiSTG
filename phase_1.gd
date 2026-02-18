extends Node

var original_position : Vector2
var position : Vector2

const needle_bullet = preload('res://needle_bullet.tscn')
const bullet = preload('res://fire_bullet.tscn')

@export var target_position = Vector2(global.field_width/2.0, global.field_height/3.0)
@export var target_position1 = Vector2(global.field_width * 0.97, global.field_height/3.0)
@export var target_position2 = Vector2(global.field_width * 0.03, global.field_height/3.0)
@export var enter_time = 4.0
@export var patrol_time = 2.0
@export var transition_x = Tween.TRANS_SINE
@export var transition_y = Tween.TRANS_QUAD

@export var fire_time = 1.0
@export var nfire = 30
@export var start_angle = 0.0
@export var stop_angle = PI/2
@export var offset = Vector2.ZERO
@export var transition = Tween.TRANS_SINE
@export var speed = 4.0
@export var fire_jitter = 5
@export var nneedles = 30
@export var needle_spread_x = 140.0
@export var needle_spread_y = 20.0
@export var wait_time = 1.0

var fire_interval = fire_time/nfire
var precision = 100.0

var phase_done = false
var control_tween
var homing_tween

func _ready():
	original_position = position
	
	
func spiral_arm(node: Node2D, angle1, angle2, positive):
	var angle
	var velocity : Vector2
	if positive:
		if angle2 < angle1:
			angle2 = angle2 + 2*PI
	else:
		if angle2 > angle1:
			angle2 = angle2 - 2*PI
		
	for i in nfire:
		angle = Tween.interpolate_value(angle1,angle2 - angle1,i,nfire-1,transition,Tween.EASE_IN)
		var tmp = bullet.instantiate()
		velocity = speed * Vector2.from_angle(angle) + node.velocity
		tmp.speed = velocity.length()
		tmp.position = node.position + offset + fire_jitter * Vector2(1,0) * global.rng.randf()
		tmp.direction = velocity.normalized()
		node.add_sibling(tmp)
		await get_tree().create_timer(fire_interval).timeout
	
	
func fire1(node: Node2D):
	var angle_stop = node.position.angle_to_point(Vector2(0,global.field_height))
	spiral_arm(node,0, angle_stop, true)

	
func fire2(node: Node2D):
	var angle_stop = node.position.angle_to_point(Vector2(global.field_width,global.field_height))
	spiral_arm(node, PI, angle_stop , false)


	
var home_time = 0.25

func home_player(node : Node2D):
	var ttween = self.create_tween()
	ttween.tween_property(node, 'position:x', global.player_position.x, home_time)
	ttween.parallel().tween_property(node, 'position:y', 60.0, home_time)


func spawn_needles(node : Node2D):
	for i in nneedles:
		var tmp = needle_bullet.instantiate()
		tmp.position = node.position
		tmp.position.x = tmp.position.x + global.rng.randf_range(-needle_spread_x,needle_spread_x)
		tmp.position.y = tmp.position.y + global.rng.randf_range(-needle_spread_y,needle_spread_y)
		node.add_sibling(tmp)
		
func aimed_needles(node : Node2D):
	var tmp = needle_bullet.instantiate()
	tmp.position.y = 40.0
	tmp.position.x = global.player_position.x
	node.add_sibling(tmp)
	
func aimed_bullet(node : Node2D):
	var tmp = needle_bullet.instantiate()
	tmp.position.y = 40.0
	tmp.position.x = global.player_position
	node.add_sibling(tmp)
	

func home_center(node : Node2D):
	var ttween = self.create_tween()
	ttween.tween_property(node, 'position:x', global.field_width/2.0, home_time)
	ttween.parallel().tween_property(node, 'position:y', global.field_width/3.0, home_time)


func stop_homing():
	homing_tween.stop()
	
func start_homing():
	homing_tween.play()
	

func run(node: Node2D):
	
	homing_tween = self.create_tween()
	homing_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	homing_tween.set_loops()
	homing_tween.tween_callback(aimed_needles.bind(node))
	homing_tween.tween_interval(1.0)
	homing_tween.stop()

	control_tween = self.create_tween()
	control_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	control_tween.set_loops()
	control_tween.tween_callback(home_center.bind(node))
	control_tween.tween_interval(home_time+0.1)
	control_tween.tween_callback(fire1.bind(node))
	control_tween.tween_interval(fire_time + wait_time)
	control_tween.tween_callback(home_player.bind(node))
	control_tween.tween_interval(home_time)
	control_tween.tween_callback(spawn_needles.bind(node))
	
	control_tween.tween_callback(home_center.bind(node))
	control_tween.tween_interval(home_time+0.1)
	control_tween.tween_callback(fire2.bind(node))
	control_tween.tween_interval(fire_time + wait_time)
	control_tween.tween_callback(home_player.bind(node))
	control_tween.tween_interval(home_time)
	control_tween.tween_callback(spawn_needles.bind(node))
	control_tween.tween_callback(start_homing)
	
