extends Node

const bullet = preload('res://bullet.tscn')


var t = 0.0
@export var fire_interval = 1.0
@export var speed = 3.0
@export var fire_spread = 1.0
var this_fire_interval: float
@export var direction = Vector2.DOWN
@export var oneshoot = false
@export var randomize_phase = false


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
	var tmp = bullet.instantiate()
	tmp.speed = speed
	tmp.position = node.position
	tmp.direction = direction
	node.add_sibling(tmp)
	if oneshoot:
		queue_free()
