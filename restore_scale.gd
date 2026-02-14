extends Node

var restore_speed = 1.0 # per frames

func advance(node : Node2D, delta):
	
	node.scale.x = move_toward(node.scale.x,1.0, restore_speed * delta * global.target_FPS)
	node.scale.y = move_toward(node.scale.y,1.0, restore_speed * delta * global.target_FPS)
