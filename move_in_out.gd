extends Node2D

@export var enter_speed = 4.0
@export var exit_speed = 4.0
@export var wait_time = 1.0
var enter_time: float
var exit_time: float
var t = 0

@export var enter_direction = Vector2.LEFT
@export var exit_direction = Vector2.RIGHT
@export var transition_x = Tween.TRANS_SINE
@export var transition_y = Tween.TRANS_QUAD
var target_position : Vector2
var enter_position : Vector2
var exit_position : Vector2

var d = 4.0**2

enum {ENTER, WAIT, EXIT}
var state = ENTER

func calculate_initial_position(direction):
	var s1: float
	var s2: float
	var buffer = 40.0
	var thresh = 0.01
	if direction.y < thresh:
		s1 = (target_position.y - global.field_height - buffer)/direction.y
	elif direction.y > thresh:
		s1 = (target_position.y + buffer)/direction.y
	else:
		s1 = INF
	if direction.x < thresh:
		s2 = (target_position.x - global.field_width - buffer)/direction.x
	elif direction.x > thresh:
		s2 = (target_position.x + buffer)/direction.x
	else:
		s2 = INF
	print('s11111')
	print(s2)
	print(s1)
	var s = min(s1,s2)
	print(s)
	return target_position - direction * s

func _ready():
	enter_direction = enter_direction.normalized()
	exit_direction = exit_direction.normalized()
	target_position = global_position
	enter_position = calculate_initial_position(enter_direction)
	
	if enter_position.distance_squared_to(global.player_position) < 10000:
		enter_direction.x = -enter_direction.x
		enter_position = calculate_initial_position(enter_direction)
	
	exit_position =  calculate_initial_position(-exit_direction)
	position = enter_direction
	enter_time = target_position.distance_to(enter_position)/enter_speed/global.target_FPS
	exit_time =  target_position.distance_to(exit_position)/exit_speed/global.target_FPS
	print(target_position)
	print(enter_position)
	print(enter_time)
	print(enter_direction)

func advance(_node, delta):
	match state:
		ENTER:
			t = t + delta
			position.x = Tween.interpolate_value(enter_position.x,target_position.x-enter_position.x,t,enter_time,transition_x,Tween.EASE_OUT)
			position.y = Tween.interpolate_value(enter_position.y,target_position.y-enter_position.y,t,enter_time,transition_y,Tween.EASE_OUT)
			if t > enter_time:
				t = 0.0
				state = WAIT
		WAIT:
			t = t + delta
			if t > wait_time:
				t = 0.0
				state = EXIT
		EXIT:
			t = t + delta
			position.x = Tween.interpolate_value(target_position.x,exit_position.x-target_position.x,t,exit_time,transition_x,Tween.EASE_IN)
			position.y = Tween.interpolate_value(target_position.y,exit_position.y-target_position.y,t,exit_time,transition_y,Tween.EASE_IN)
