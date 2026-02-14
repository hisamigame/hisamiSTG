extends Enemy

enum STATE{ENTER,LINGER,LEAVE}
var state = STATE.ENTER

@onready var avg_position = position
@export var speed = 1.0
@export var direction = Vector2.ZERO

func _ready():
	super._ready()
	$EnterMovement.position = position
	$EnterMovement.direction = direction

func die():
	init_revenge_bullet()
	global.set_score(global.score + value)
	die_no_bonus()

func _physics_process(delta: float) -> void:
	
	match state:
		STATE.ENTER:
			$EnterMovement.advance(self,delta)
			$Bobbing.advance(self,delta)
			position = $EnterMovement.position
			position = position + $Bobbing.position
