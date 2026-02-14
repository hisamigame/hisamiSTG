extends Enemy

func _ready() -> void:
	super._ready()
	if get_node_or_null('Movement'):
		$Movement.position = position

func _physics_process(delta: float) -> void:
	
	if not has_been_seen:
		process_seen()
		if has_been_seen:
			can_fire = true
			
	
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
	if check_oob():
		die_no_nothing()
		
