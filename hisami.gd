extends Node2D

@export var unfocused_speed = 8.0
@export var focus_speed = 5.0
var speed = unfocused_speed

@export var margin = 10

@onready var position_min = Vector2(margin,margin)
@onready var position_max = Vector2(global.field_width - margin,global.field_height - margin)

enum {DEFAULT, TOLEFT, LEFT, TORIGHT, RIGHT}
var anim_state = DEFAULT
var anim_t = 0.0
var anim_time = 0.1

enum {NORMAL, ENTERING, HYPER}
var hyperstate = NORMAL
var enter_hyper_time = 1.2
var t = 0


var n_shots = 4
var n_hyper_shots = 8
var unfocused_offset = 12.0
var focused_offset = 4.0
var shot_parity = 0

var shot_time = 0.1
var can_shoot = true

signal got_hurt

const attack = preload("res://normal_shot.tscn")
const hyper_attack = preload("res://hyper_shot.tscn")
const bomb_effect = preload('res://bomb_effect.tscn')

const damage_invul_time = 3.5
var can_take_damage = true

func focused_shot():
	unfocused_shot(false)
	
func hyper_focused_shot():
	hyper_unfocused_shot(false)

func _ready():
	$Hitbox.took_damage.connect(take_damage)
	global.player_position = position

func damage_invul():
	can_take_damage = false
	modulate.a = 0.5
	
func damage_not_invul():
	can_take_damage = true
	modulate.a = 1.0

func enter_hyper():
	print('enter hyper')
	global.set_ammo(global.ammo - global.hyper_cost)
	var tmp = bomb_effect.instantiate()
	tmp.player = self
	add_sibling(tmp)
	global.hyper_t = global.default_hypertime
	global.set_hyperlevel(global.hyperlevel + 1)
	if hyperstate == NORMAL:
		hyperstate = ENTERING
		$InvulTimer.start(enter_hyper_time)
		damage_invul()
	elif hyperstate == HYPER:
		hyperstate = ENTERING
		$InvulTimer.start(enter_hyper_time)
		damage_invul()

func process_animation(delta, direction):
	match anim_state:
		DEFAULT:
			if direction.x > 0.1:
				anim_state = RIGHT
			elif direction.x < -0.1:
				anim_state = LEFT
		LEFT:
			if direction.x > -0.1:
				anim_state = TORIGHT
		RIGHT:
			if direction.x < 0.1:
				anim_state = TOLEFT
		TOLEFT:
			if direction.x < -0.1:
				anim_t = anim_t + delta
				if anim_t > anim_time:
					anim_state = LEFT
					anim_t = 0.0
				
		TORIGHT:
			if direction.x > 0.1:
				anim_t = anim_t + delta
				if anim_t > anim_time:
					anim_state = RIGHT
					anim_t = 0.0
				
				
	match anim_state:
		DEFAULT, TOLEFT, TORIGHT:
			$AnimatedSprite2D.play('default')
		RIGHT:
			$AnimatedSprite2D.play('move')
			$AnimatedSprite2D.flip_h = false
		LEFT:
			$AnimatedSprite2D.play('move')
			$AnimatedSprite2D.flip_h = true
		

func _physics_process(delta: float) -> void:
	var direction = global.get_movement_direction()
	if global.focus:
		speed = focus_speed
	else:
		speed = unfocused_speed
	process_animation(delta, direction)

	
	position = (position + direction * delta * speed * global.target_FPS).clamp(position_min, position_max)
	global.set_player_position(position)
	
	match hyperstate:
		NORMAL:
			if global.fire:
				fire()
			if global.hyper and global.ammo >= global.hyper_cost:
				enter_hyper()
		ENTERING:
			t = t + delta
			if t > enter_hyper_time:
				hyperstate = HYPER
				t = 0
		HYPER:
			global.hyper_t = global.hyper_t - delta
			if global.hyper_t < 0:
				leave_hyper()
			if global.fire:
				fire()
			if global.hyper and global.ammo >= global.hyper_cost:
				enter_hyper()
			
	
func leave_hyper():
	global.hypertime = global.default_hypertime
	hyperstate = NORMAL
	global.set_hyperlevel(0)
	
	
func take_damage(_hurtbox: Hurtbox):
	if can_take_damage:
		global.set_lives(global.lives - 1)
		$InvulTimer.start(damage_invul_time)
		damage_invul()
		got_hurt.emit()
		if global.lives >= 0:
			global.emit_clear_bullets(true, true)
			global.emit_collect_items()
			global.play_player_hurt()
		else:
			global.play_player_dead()
	
func die():
	modulate =Color(18.892, 18.892, 18.892, 1.0)
	$Hitbox.queue_free.call_deferred()
	set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)

func hyper_unfocused_shot(spread):
	var shot_direction: Vector2
	var opening
	var linear_offset = 10.0
	var offset = 40.0
	if spread:
		opening = PI/12
	else:
		opening = PI/24
	var step = 2*opening/(n_hyper_shots-1)
	var offset_step = 2*linear_offset/(n_hyper_shots-1)
	
	for i in n_hyper_shots:
		var tmp = hyper_attack.instantiate()
		var angle =  -PI/2 + step * i - opening
		shot_direction = Vector2.from_angle(angle)
		tmp.fired_position = global_position
		tmp.direction = shot_direction	
		tmp.position = position + shot_direction * offset
		tmp.position.x = tmp.position.x + (offset_step * i - linear_offset)
		add_sibling(tmp)

func unfocused_shot(spread):
	var shot_direction: Vector2
	var xoffset: float
	var yoffset
	for i in n_shots:
		var tmp = attack.instantiate()
		shot_direction = Vector2.UP
		tmp.fired_position = global_position
		
		
		if spread:
			@warning_ignore("integer_division")
			xoffset = unfocused_offset * (0.5 + i-n_shots/2)
		else:
			@warning_ignore("integer_division")
			xoffset = focused_offset * (0.5 + i-n_shots/2)
		
		
		if i == 0 or i == n_shots - 1:
			yoffset = tmp.offset.y * 0.9
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
		#if i == 0:
		#	tmp.position.x = tmp.position.x - 10
		tmp.direction = shot_direction
		add_sibling(tmp)

func _on_invul_timer_timeout() -> void:
	damage_not_invul()
	
func fire():
	match hyperstate:
		NORMAL:
			if can_shoot:
				if global.focus:
					focused_shot()
				else:
					unfocused_shot(true)
				can_shoot = false
				$ShotTimer.start(shot_time)
				shot_parity = (shot_parity + 1)%2
		HYPER:
			if can_shoot:
				if global.focus:
					hyper_focused_shot()
				else:
					hyper_unfocused_shot(true)
				can_shoot = false
				$ShotTimer.start(shot_time)
				shot_parity = (shot_parity + 1)%2

func _on_shot_timer_timeout() -> void:
	can_shoot = true
