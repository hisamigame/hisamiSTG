extends Node2D
class_name Enemy


const death_effect = preload('res://death_effect.tscn')
const item = preload('res://item.tscn')

@export var hp = 10
@export var value= 100
@export var special_immune = false
@export var can_fire = false
@export var seal_distance2 = 60.0**2
@export var edge_seal_distance = 60
var sealed = false
@export var spawn_delay = 0.0
@export var clear_margin = 40
var can_die = false
var has_been_seen = false
var can_damage = true
var seen_margin = 10

var enemy_index: int
signal died(int)

func process_seen():
	if not has_been_seen:
		if position.x < global.field_width and position.x > 0 and position.y < global.field_height and position.y > seen_margin:
			has_been_seen = true
	return has_been_seen
	

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
	
func check_edge_seal():
	var ret = false
	if position.y > global.field_height - edge_seal_distance:
		ret = true
	return ret



func die_no_bonus():
	var tmp = death_effect.instantiate()
	tmp.position = position
	add_sibling.call_deferred(tmp)
	global.play_enemy_dead()
	die_no_nothing()
	
func die_no_nothing():
	died.emit(enemy_index)
	queue_free()

func die():
	global.set_score(global.score + value)
	die_no_bonus()
	

func _ready() -> void:
	$Hitbox.took_damage.connect(take_damage)

func spawn_item(spawn_position):
	var tmp = item.instantiate()
	tmp.position = spawn_position
	add_sibling.call_deferred(tmp)

func take_damage(hurtbox: Hurtbox):
	if can_damage:
		global.play_enemy_hurt()
		hp = hp - hurtbox.damage
		spawn_item(hurtbox.position)
		if (hp <= 0) and can_die:
			can_die = false
			die()
