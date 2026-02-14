extends Hurtbox
class_name Bullet

@export var direction: Vector2
@export var speed = 4.0
@export var can_graze = true
@export var graze_value = 5
@export var value = 20

@export var clearable = true
@export var revenge_bullet = false

const clear_margin = 50.0
const item = preload('res://item.tscn')
const remove_effect = preload('res://bullet_remove_effect.tscn')

func _ready() -> void:
	$AnimatedSprite2D.play('default')

func check_oob():
	if position.x > global.field_width + clear_margin:
		queue_free()
	elif position.x <  -clear_margin:
		queue_free()
	if position.y > global.field_height + clear_margin:
		queue_free()
	elif position.y <  -clear_margin:
		queue_free()
	

func _physics_process(delta: float) -> void:
	position = position + delta * direction * speed * global.target_FPS
	check_oob()
	
	
func just_die():
	queue_free()
	
func die():
	var tmp = remove_effect.instantiate()
	tmp.position = position
	add_sibling.call_deferred(tmp)
	just_die()
	
func become_item(collect_time: float = -1):
	var tmp = item.instantiate()
	tmp.position = position
	tmp.collect_time = collect_time
	add_sibling.call_deferred(tmp)
	
func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		if area.clear_bullets and clearable:
			if area.clear_revenge_bullets:
				become_item(global.item_collect_time)
				just_die()
			else:
				die()
			
		elif area.clear_revenge_bullets and revenge_bullet:
			become_item(global.item_collect_time)
			just_die()
