extends Area2D
class_name Hitbox

signal took_damage(Hurtbox)

func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		took_damage.emit(area)
