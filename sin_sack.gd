extends Enemy

var damage_position: Vector2

const fallen_sack = preload("res://fallen_sack.tscn")
const enemy_hit_material = preload("res://enemy_hit_shader.tres")
const big_impact = preload('res://big_impact.tscn')

enum FLAVOR{DEFAULT, FIRE, WATER, LIGHTNING, WIND}
@export var flavor: FLAVOR = FLAVOR.DEFAULT

var flashed_frames = 0
var flashing = false

func _ready():
	super._ready()

func die():
	global.set_score(global.score + value)
	die_no_bonus()
	
func die_no_bonus():
	global.play_enemy_dead()
	var tmp = fallen_sack.instantiate()
	tmp.fired_position = damage_position
	tmp.position = position	
	match flavor:
		FLAVOR.DEFAULT:
			tmp.set_flavor('default')
		FLAVOR.FIRE:
			tmp.set_flavor('fire')
		FLAVOR.WATER:
			tmp.set_flavor('water')
		FLAVOR.LIGHTNING:
			tmp.set_flavor('ligtning')
		FLAVOR.WIND:
			tmp.set_flavor('wind')
	add_sibling.call_deferred(tmp)
	var tmp2 = big_impact.instantiate()
	tmp2.position = position
	add_sibling.call_deferred(tmp2)
	super.die_no_nothing()
	

func _physics_process(delta: float) -> void:
	if not has_been_seen:
		process_seen()
		if has_been_seen:
			can_fire = true
			can_die = true
	else:
		if check_oob():
			die_no_nothing()	
	
	if has_node('Movement'):
		$Movement.advance(self, delta)
		position = $Movement.position
	if has_node('Bobbing'):
		$Bobbing.advance(self,delta)
		position = position + $Bobbing.position
	if has_node('Shoot'):
		if can_fire and check_edge_seal() or position.distance_squared_to(global.player_position) < seal_distance2:
			sealed = true
		else:
			sealed = false
		$Shoot.advance(self,delta)
		
	if flashing:
		if flashed_frames >= 1:
			unset_enemy_material()
			flashing = false
		flashed_frames = flashed_frames + 1
	
func take_damage(hurtbox: Hurtbox):
	damage_position = hurtbox.fired_position
	super.take_damage(hurtbox)
	
	$AnimatedSprite2D.material = enemy_hit_material
	flashed_frames = 0
	flashing = true
	#enemy_flash_timer.start()

func unset_enemy_material():
	$AnimatedSprite2D.material = null
