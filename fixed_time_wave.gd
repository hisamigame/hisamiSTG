extends Wave

const bonus_enemy = preload('res://sin_sack_default.tscn')
const bonus_movement = preload("res://linear_movement.tscn")
@export var bonus_speed = 2.0

func enemy_died(i):
	living_enemies[i] = false
	var sum =0
	for le in living_enemies:
		sum = sum + int(le)
	if sum == 0:
		spawn_extra()


func spawn_extra():
	var tmp = bonus_enemy.instantiate()
	var movement = bonus_movement.instantiate()
	tmp.position = Vector2(global.player_position.x,-30.0)
	movement.speed = bonus_speed
	tmp.add_child(movement)
	tmp.enemy_index = 0
	tmp.died.connect(enemy_died)
	living_enemies[0] = true
	add_sibling.call_deferred(tmp)
