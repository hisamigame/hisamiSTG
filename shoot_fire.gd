extends Node


var t = 0.0
@export var fire_interval = 1.0
@export var speed = 3.0
@export var fire_spread = 1.0
@export var oneshoot = false
var this_fire_interval: float
@export var randomize_phase = false
@export var nbullets = 3
@export var speeds = [4,3,2]
@export var initial_phase = 0.0


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
	$Shoot1.fire(node)
	$Shoot2.fire(node)
	if oneshoot:
		queue_free()
