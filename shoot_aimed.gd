extends Node

const bullet = preload('res://bullet.tscn')


var t = 0.0
@export var fire_interval = 1.0
@export var speed = 3.0

func advance(node, delta):
	if node.can_fire and not node.sealed:
		t = t + delta
		if t > fire_interval:
			fire(node)
			t = 0.0
			
func fire(node):
	var tmp = bullet.instantiate()
	tmp.speed = speed
	tmp.position = node.position
	tmp.direction = tmp.position.direction_to(global.player_position)
	node.add_sibling(tmp)
