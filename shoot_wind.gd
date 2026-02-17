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
var i_direction = -1
var ndirections = 12
@export var gap = 30.0
@export var drift = 1.61803398875 * 5
var random_offset


func random_interval():
	return fire_interval + global.rng.randf_range(-fire_spread,fire_spread)

func _ready() -> void:
	random_offset = global.rng.randf_range(70.0,110.0)
	this_fire_interval = random_interval()
	if randomize_phase:
		t = global.rng.randf_range(0,this_fire_interval)
	cycle_directions()
	

func cycle_directions():
	i_direction = i_direction + 1
	var i = i_direction % ndirections
	var factor
	@warning_ignore("integer_division")
	if i > ndirections/4 and i <  3*ndirections/4:
		factor = -1.0
	else:
		factor = 1.0
	@warning_ignore("integer_division")
	var angle = 150.0 + (i/2) * (360.0/ndirections) * factor + (i %2) * 180
	$Shoot1.set_direction(Vector2.from_angle(deg_to_rad(random_offset + drift * i_direction + angle + gap/2)))
	$Shoot2.set_direction(Vector2.from_angle(deg_to_rad(random_offset + drift * i_direction + angle - gap/2)))

func advance(node, delta):
	if node.can_fire and not node.sealed:
		t = t + delta
		if t > this_fire_interval:
			fire(node)
			cycle_directions()
			this_fire_interval = random_interval()
			t = 0.0
			
func fire(node):
	$Shoot1.fire(node)
	$Shoot2.fire(node)
	if oneshoot:
		queue_free()
