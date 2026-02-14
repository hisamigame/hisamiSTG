extends Node

@export var speed = 1.0
@export var direction = Vector2.DOWN
var position: Vector2

func advance(_node, delta):
	position = position + speed * direction * delta * global.target_FPS
