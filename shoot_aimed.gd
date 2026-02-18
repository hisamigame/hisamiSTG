extends Node

const bullet = preload('res://bullet.tscn')


var t = 0.0
@export var fire_interval = 1.0
@export var speed = 3.0
@export var fire_spread = 1.0
@export var oneshoot = false
var this_fire_interval: float
@export var randomize_phase = false
@export var initial_phase = 0.0
var has_fired = false
var can_fire = true

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
		if t > this_fire_interval and can_fire:
			fire(node)
			this_fire_interval = random_interval()
			t = 0.0
			
func fire(node):
	var tmp = bullet.instantiate()
	tmp.speed = speed
	tmp.position = node.position
	tmp.direction = tmp.position.direction_to(global.player_position)
	node.add_sibling(tmp)
	has_fired = true
	if oneshoot:
		can_fire = false
