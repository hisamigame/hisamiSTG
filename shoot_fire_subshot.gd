extends Node

const bullet = preload('res://fire_bullet.tscn')


var t = 0.0
@export var fire_interval = 0.1
@export var speed = 3.0
@export var fire_spread = 0.0
var this_fire_interval: float
#@export var direction = Vector2.DOWN
@export var oneshoot = false
@export var randomize_phase = false

@export var nbullets = 10
@export var start_angle = 0.0
@export var stop_angle = PI/2
@export var offset = Vector2.ZERO
@export var transition = Tween.TRANS_SINE


func random_interval():
	return fire_interval + global.rng.randf_range(-fire_spread,fire_spread)

func _ready() -> void:
	this_fire_interval = random_interval()
	if randomize_phase:
		t = global.rng.randf_range(0,this_fire_interval)

func advance(node, delta):
	if node.can_fire and not node.sealed:
		t = t + delta
		if t > this_fire_interval:
			fire(node)
			this_fire_interval = random_interval()
			t = 0.0
			
func fire(node):
	var angle
	for i in nbullets:
		angle = Tween.interpolate_value(start_angle,stop_angle - start_angle,i,nbullets-1,transition,Tween.EASE_IN_OUT)
		var tmp = bullet.instantiate()
		tmp.speed = speed
		tmp.position = node.position + offset
		tmp.direction = Vector2.from_angle(angle)
		node.add_sibling(tmp)
		await get_tree().create_timer(fire_interval).timeout
	if oneshoot:
		queue_free()
