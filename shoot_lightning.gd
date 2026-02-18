extends Node

const bullet = preload("res://lightning_bullet.tscn")
const charge_effect = preload('res://lightning_charge_visuals.tscn')

var t = 0.0
@export var fire_interval = 6.0
@export var speed = 4.0
@export var fire_spread = 1.0
@export var oneshoot = false
var this_fire_interval: float
@export var randomize_phase = false
@export var nbullets_width = 3
@export var acc = 0.1
@export var jitter = 0
@export var initial_phase = 0.0
@export var start_up_time = 0.2
@export var nticks = 30
@export var tick_duration = 0.1
@export var width = 20.0
@export var frame_hack = true
var frame_velocity = Vector2.ZERO

var tween
var direction
var line



func spawn_one_tick(node):
	var start_pos = node.movement_node.position - line * width/2
	var end_pos = node.movement_node.position + line * width/2
	var velocity : Vector2
	for i in nbullets_width:
		var tmp = bullet.instantiate()
		tmp.accel = acc
		tmp.position = start_pos + (end_pos - start_pos) * i/(nbullets_width - 1.0)
		tmp.position = tmp.position + jitter * Vector2.from_angle(global.rng.randf_range(0,2*PI))
		velocity = speed * direction + node.movement_node.speed *  node.movement_node.direction
		tmp.direction = velocity.normalized()
		tmp.speed = velocity.length()
		
		node.add_sibling(tmp)
		node.violent_death.connect(tmp.become_item_and_die)
	
func take_aim(node : Node2D):
	direction = node.position.direction_to(global.player_position)
	line = direction.orthogonal()

func random_interval():
	return fire_interval + global.rng.randf_range(-fire_spread,fire_spread)

func set_phase():
	if randomize_phase:
		t = initial_phase + global.rng.randf_range(0,this_fire_interval)
	else:
		t = initial_phase

func _ready() -> void:
	this_fire_interval = random_interval()
	set_phase()
	

func advance(node, delta):
	if node.can_fire and not node.sealed:
		t = t + delta
		if t > this_fire_interval:
			fire(node)
			this_fire_interval = random_interval()
			t = 0.0
			
func fire(node):
	var tmp = charge_effect.instantiate()
	tmp.duration = start_up_time
	node.add_child(tmp)
	take_aim(node)
	tween = self.create_tween()
	tween.tween_interval(start_up_time)
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	for i in nticks:
		tween.tween_callback(spawn_one_tick.bind(node))
		tween.tween_interval(tick_duration)
	if oneshoot:
		queue_free()
