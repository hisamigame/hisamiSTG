extends Hurtbox

var expand_speed = 2.0 # pixel per frame
#var default_radius = 16.0
var radius = 22.0 # start radius
var lifetime = 0.0
var max_lifetime = 0.1
var pure_death = false
@onready var shader_size = $ColorRect.size

func kill():
	# # needed since all charge attacks share shape
	#$CollisionShape2D.shape.radius = default_radius
	$ColorRect.get_material().set_shader_parameter("time", 0.0)
	queue_free()
	
func _ready():
	$ColorRect.get_material().set_shader_parameter("start_coord", Vector2.ONE*0.5)
	$ColorRect.get_material().set_shader_parameter("wave_speed", expand_speed * global.target_FPS/shader_size[0])
	$ColorRect.get_material().set_shader_parameter("start_time", -(radius/expand_speed)/global.target_FPS)
	$ColorRect.get_material().set_shader_parameter("pixel_size", shader_size)
	$ColorRect.get_material().set_shader_parameter("max_time", max_lifetime)

func _physics_process(delta: float) -> void:
	lifetime = lifetime + delta
	radius = radius +  expand_speed * delta * global.target_FPS
	$CollisionShape2D.shape.radius = radius
	$ColorRect.get_material().set_shader_parameter("time", lifetime)
	if lifetime > max_lifetime:
		kill()
