extends Node2D

signal boss_dead
var dead = false

var can_take_damage = true

var max_hp = 100
var hp = 100

var phase = -1
var hp_phases = [10.0, 100.0, 100] #[200,200,200]
const item = preload('res://item.tscn')
@export var animation_change_movement_threshold = 3.0

var prev_position : Vector2
var velocity : Vector2


func enter_phase(i):
	phase = i
	hp = hp_phases[i]
	max_hp = hp_phases[i]
	match i:
		0:
			$Phase0.run(self)
		1:
			$Phase0.queue_free()
			$Phase1.run(self)
		2:
			$Phase1.queue_free()
			$Phase2.run(self)

func start_fight():
	enter_phase(0)
	global.emit_clear_enemies()

func _ready():
	prev_position = position
	
func _process(delta: float) -> void:
	if position.x > prev_position.x + animation_change_movement_threshold:
		$AnimatedSprite2D.play('move')
		$AnimatedSprite2D.flip_h = false
	elif position.x < prev_position.x - animation_change_movement_threshold:
		$AnimatedSprite2D.play('move')
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play('default')
	velocity = (position - prev_position)/(delta * global.target_FPS)
	prev_position = position
	

func switch_phase():
	#play_serious_hurt()
	clear_bullets()
	# need to know if dead before await is done
	dead = ((phase+1) >= len(hp_phases))
	
	if not dead:
		enter_phase(phase+1)
	else:
		die()

func clear_bullets():
	global.emit_clear_bullets(true, false)
	global.emit_clear_enemies()

func set_hp_bar_value(val):
	$CanvasLayer/TextureProgressBar.value = 100 * val/max_hp

func die():
	clear_bullets()
	boss_dead.emit()
	print('die')
	queue_free()

func take_damage(dmg):
	if  can_take_damage:
		hp = hp - dmg
		global.play_enemy_hurt()
		set_hp_bar_value(hp)
		if hp < 0.0:
			switch_phase()
			#can_take_damage = false

func spawn_item(spawn_position):
	var tmp = item.instantiate()
	tmp.position = spawn_position
	add_sibling.call_deferred(tmp)

func _on_hitbox_took_damage(hurtbox: Variant) -> void:
	spawn_item(hurtbox.position)
	take_damage(hurtbox.damage)
