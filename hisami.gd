extends Node2D

@export var speed = 8.0

@export var margin = 10

@onready var position_min = Vector2(margin,margin)
@onready var position_max = Vector2(global.field_width - margin,global.field_height - margin)

var n_shots = 4
var unfocused_offset = 12.0
var focused_offset = 4.0
var shot_parity = 0

var shot_time = 0.1
var can_shoot = true

signal got_hurt

const attack = preload("res://normal_shot.tscn")

const damage_invul_time = 3.5
var can_take_damage = true

func focused_shot():
	unfocused_shot(false)

func _ready():
	$Hitbox.took_damage.connect(take_damage)
	global.player_position = position

func damage_invul():
	can_take_damage = false
	modulate.a = 0.5
	
func damage_not_invul():
	can_take_damage = true
	modulate.a = 1.0

func _physics_process(delta: float) -> void:
	var direction = global.get_movement_direction()
	
	position = (position + direction * delta * speed * global.target_FPS).clamp(position_min, position_max)
	global.set_player_position(position)
	if global.fire:
		fire()
	
func take_damage(_hurtbox: Hurtbox):
	if can_take_damage:
		global.set_lives(global.lives - 1)
		$InvulTimer.start(damage_invul_time)
		damage_invul()
		got_hurt.emit()
		if global.lives >= 0:
			global.play_player_hurt()
		else:
			global.play_player_dead()
	
func die():
	modulate =Color(18.892, 18.892, 18.892, 1.0)
	$Hitbox.queue_free.call_deferred()
	set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)

func unfocused_shot(spread):
	var shot_direction: Vector2
	var xoffset: float
	var yoffset
	for i in n_shots:
		var tmp = attack.instantiate()
		shot_direction = Vector2.UP
		
		
		if spread:
			@warning_ignore("integer_division")
			xoffset = unfocused_offset * (0.5 + i-n_shots/2)
		else:
			@warning_ignore("integer_division")
			xoffset = focused_offset * (0.5 + i-n_shots/2)
		
		
		if i == 0 or i == n_shots - 1:
			yoffset = tmp.offset.y * 0.5
			#xoffset = xoffset * 0.9
			if spread:
				if shot_parity == 0:
					if i == 0:
						shot_direction.x = -0.1
					else:
						shot_direction.x = 0.1
			else:
				if i == 0:
					shot_direction.x = 0.05
				else:
					shot_direction.x = -0.05
		else:
			yoffset = tmp.offset.y
			
		tmp.position = position# + tmp.offset
		tmp.position.x = tmp.position.x + xoffset
		tmp.position.y = tmp.position.y + yoffset
		print(i)
		#if i == 0:
		#	tmp.position.x = tmp.position.x - 10
		print(shot_direction.x)
		tmp.direction = shot_direction
		add_sibling(tmp)

func _on_invul_timer_timeout() -> void:
	damage_not_invul()
	
func fire():
	if can_shoot:
		if global.focus:
			focused_shot()
		else:
			unfocused_shot(true)
		can_shoot = false
		$ShotTimer.start(shot_time)
		shot_parity = (shot_parity + 1)%2


func _on_shot_timer_timeout() -> void:
	can_shoot = true
