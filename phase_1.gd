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

@export var nfire = 100
@export var start_angle = 0.0
@export var stop_angle = PI/2
@export var offset = Vector2.ZERO
@export var transition = Tween.TRANS_SINE
@export var speed = 4.0
@export var fire_interval = 0.01

var precision = 100.0
var bullet_interval = fire_interval * nfire * 2

var phase_done = false
var tween
var bullet_tween
var patrol_tween

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
		tmp.position = node.position + offset
		tmp.direction = velocity.normalized()
		node.add_sibling(tmp)
		await get_tree().create_timer(fire_interval).timeout
	
	
func fire(node: Node2D):
	var angle_stop = node.position.angle_to_point(Vector2(0,global.field_height))
	spiral_arm(node,0, angle_stop, true)
	angle_stop = node.position.angle_to_point(Vector2(global.field_width,global.field_height))
	await get_tree().create_timer(1.0).timeout
	spiral_arm(node, PI, angle_stop , false)


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
	
	bullet_tween.tween_callback(fire.bind(node))
	bullet_tween.tween_interval(bullet_interval)
	
	tween.tween_callback(stop_bullet_spawn)
	tween.tween_callback(stop_patrol)
	tween.tween_property(node, 'position',target_position, patrol_time/2).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(start_bullet_spawn)
	#tween.tween_property(node, 'position',target_position1, patrol_time/2).set_trans(Tween.TRANS_SINE)
	#tween.tween_callback(start_patrol)
