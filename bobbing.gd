extends Node

@export var bob_freq = 2*PI/(2)
@export var amplitude = 10
@export var direction = Vector2.UP
var position = Vector2.ZERO
var t = 0.0


func advance(_node, delta):
	t = t + delta
	position = amplitude * sin(bob_freq * t) * direction
