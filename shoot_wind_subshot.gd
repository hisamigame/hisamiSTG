extends Node

const bullet = preload('res://bullet.tscn')


var t = 0.0
@export var fire_interval = 0.05
@export var speed = 3.0
@export var fire_spread = 0.0
var this_fire_interval: float
#@export var direction = Vector2.DOWN
@export var oneshoot = false
@export var randomize_phase = false

@export var nbullets = 10
@export var start_angle = 0
@export var offset = Vector2.ZERO
@export var radius = 50
@export var transition = Tween.TRANS_LINEAR
@export var myease = Tween.EASE_IN
@export var start_point = Vector2(1,0)
@export var length = 20.0
@export var total_angle_diff = PI*15/180
@export var total_speed_diff_ratio = 1.2
@export var flipit = false
@export var direction = Vector2.LEFT
var end_point

func set_direction(d):
	direction = d.normalized()
	end_point = start_point + d * length

func random_interval():
	return fire_interval + global.rng.randf_range(-fire_spread,fire_spread)

func _ready() -> void:
	this_fire_interval = random_interval()
	if randomize_phase:
		t = global.rng.randf_range(0,this_fire_interval)
	set_direction(direction)

func advance(node, delta):
	if node.can_fire and not node.sealed:
		t = t + delta
		if t > this_fire_interval:
			fire(node)
			this_fire_interval = random_interval()
			t = 0.0
			
func fire(node):
	var angle
	var velocity
	var base_position
	var speed_factor
	for i in nbullets:
		if not flipit:
			angle = direction.angle() + Tween.interpolate_value(start_angle, total_angle_diff,i,nbullets-1,transition,myease)
		else:
			angle = direction.angle() + Tween.interpolate_value(start_angle, -total_angle_diff,i,nbullets-1,transition,myease)
		base_position = Tween.interpolate_value(start_point, end_point - start_point,i,nbullets-1,transition,myease)
		speed_factor = Tween.interpolate_value(total_speed_diff_ratio,(1-total_speed_diff_ratio) ,i,nbullets-1,transition,myease)
		var tmp = bullet.instantiate()
		velocity = speed * Vector2.from_angle(angle) * speed_factor
		tmp.position = node.position + base_position
		tmp.speed = velocity.length()
		tmp.direction = velocity.normalized()
		node.add_sibling(tmp)
		#await get_tree().create_timer(fire_interval).timeout
	if oneshoot:
		queue_free()
