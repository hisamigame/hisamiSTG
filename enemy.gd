extends Node2D
class_name Enemy


@export var bullet : PackedScene
@export var revenge_bullet : PackedScene
var death_effect = preload('res://death_effect.tscn')

@export var hp = 10
@export var value= 100
@export var special_immune = false
@export var can_fire = true
@export var spawn_delay = 0.0
@export var bullet_speed = 1.0
@export var clear_margin = 40
var can_die = true
var has_been_seen = false
var can_damage = true

var flashed = false
var flash_t1 = 0.05
var flash_t1_stunned = 0.15
var flash_t2 = 0.15


var enemy_index: int
signal died(int)



func process_seen():
	if position.x < global.field_width and position.x > 0:
		has_been_seen = true
	if  position.y < global.field_height and position.y > 0:
		has_been_seen = true
	return has_been_seen
	

func init_revenge_bullet():
	pass

func check_oob():
	var ret = false
	if position.x > global.field_width + clear_margin:
		ret = true
	elif position.x <  -clear_margin:
		ret = true
	if position.y > global.field_height + clear_margin:
		ret = true
	elif position.y <  -clear_margin:
		ret = true
	return ret


func die_no_bonus():
	var tmp = death_effect.instantiate()
	tmp.position = position
	tmp.clear_bullets = true
	add_sibling.call_deferred(tmp)
	global.play_enemy_dead()
	die_no_nothing()
	
func die_no_nothing():
	died.emit(enemy_index)
	queue_free()

func die():
	init_revenge_bullet()
	global.set_score(global.score + value)
	die_no_bonus()
	

func _ready() -> void:
	$Hitbox.took_damage.connect(take_damage)
	
func fire_aimed():
	if can_fire:
		var tmp = bullet.instantiate()
		tmp.direction = position.direction_to(global.player_position)
		tmp.position = position
		tmp.speed = bullet_speed
		add_sibling(tmp)


func take_damage(hurtbox: Hurtbox):
	if can_damage:
		global.play_enemy_hurt()
		hp = hp - hurtbox.damage
		if (hp <= 0) and can_die:
			can_die = false
			die()
