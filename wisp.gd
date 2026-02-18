extends Enemy

@export var must_fire_to_die = false
var can_really_die = true
var marked_for_death = false
var close_to_player = false

func _ready() -> void:
	super._ready()
	if get_node_or_null('Movement'):
		$Movement.position = position
	$AnimatedSprite2D.play('default')
	if must_fire_to_die:
		can_really_die = false
	
	
func die():
	super.die()
	for i in 8:
		spawn_item(position)

func _physics_process(delta: float) -> void:
	
	if not has_been_seen:
		process_seen()
		if has_been_seen:
			can_fire = true
			can_die = true
	else:
		if check_oob():
			die_no_nothing()
		if position.distance_squared_to(global.player_position) < seal_distance2:
			close_to_player = true
		else:
			close_to_player = false
	
	
	if has_node('Movement'):
		$Movement.advance(self, delta)
		position = $Movement.position
	if has_node('Bobbing'):
		$Bobbing.advance(self,delta)
		position = position + $Bobbing.position
	if has_node('Shoot'):
		if can_fire and check_edge_seal() or close_to_player:
			sealed = true
		else:
			sealed = false
		$Shoot.advance(self,delta)
		if must_fire_to_die:
			if $Shoot.has_fired or close_to_player:
				if marked_for_death:
					die()
				else:
					can_really_die = true
	
		
func take_damage(hurtbox: Hurtbox):
	if can_damage:
		global.play_enemy_hurt()
		hp = hp - hurtbox.damage
		if not marked_for_death:
			spawn_item(hurtbox.position)
		if (hp <= 0):
			if can_die and can_really_die:
				can_die = false
				die()
			elif not can_really_die and can_die:
				marked_for_death = true
				can_die = false
