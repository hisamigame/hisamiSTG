extends Node2D

signal boss_dead
var dead = false

var can_take_damage = true

var max_hp = 100
var hp = 100

var current_phase = 0
var hp_phases = [100.0]

func enter_phase(i):
	current_phase = i
	hp = hp_phases[i]
	max_hp = hp_phases[i]
	
	# FILL IN STUFF
	if current_phase == 0:
		pass
	else:
		pass

func _ready():
	#modulate.a = 0.0
	enter_phase(0)
	global.emit_clear_enemies()

func switch_phase():
	#play_serious_hurt()
	clear_bullets()
	# need to know if dead before await is done
	dead = ((current_phase+1) >= len(hp_phases))
	if not dead:
		# refill HP bar
		pass
	else:
		die()

func clear_bullets():
	global.emit_clear_bullets(true)
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
			can_take_damage = false


func _on_hitbox_took_damage(hurtbox: Variant) -> void:
	take_damage(hurtbox.damage)
