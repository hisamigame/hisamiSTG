extends Control

var score
var total
var time_left
var lives_left
var bonus
var message

var animation_finished = false
var time = 0.0
var minimum_time = 0.25
var do_switch = false

var next_scene = preload('res://hiscore_screen.tscn')

@onready var score_label = $SubViewport/CenterContainer/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/HSplitContainer/Label3
@onready var time_label = $SubViewport/CenterContainer/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/HSplitContainer2/Label2
@onready var lives_label = $SubViewport/CenterContainer/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/HSplitContainer3/Label2
@onready var bonus_label = $SubViewport/CenterContainer/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/HSplitContainer4/Label2
@onready var total_label = $SubViewport/CenterContainer/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/HSplitContainer5/Label2
@onready var message_label = $SubViewport/CenterContainer/MarginContainer/MarginContainer/CenterContainer/VBoxContainer/Label

func _ready() -> void:
	message_label.text = message
	score = roundi(global.score)
	time_left = snappedf(max(0.0, global.time_left), 0.01)
	lives_left = max(global.lives,0)
	#bonus = roundi(global.bonus)
	#total = roundi(global.score + global.bonus)
	total = global.score
	# if funny rounding errors happen
	# add or subtract to score to make it add up
	#if bonus + score < total:
	#	score = score+1
	#elif bonus + score > total:
	#	score = score - 1
	
	score_label.text = str(score)
	time_label.text = str(time_left)
	lives_label.text = str(lives_left)
	#if bonus > 0:
	#	bonus_label.text = str(bonus)
	#else:
	#	bonus_label.text = 'No bonus'
	total_label.text = str(total)
	
	$AnimationPlayer.play("fadeOut")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire") and time > minimum_time:
		do_switch = true

func _physics_process(delta: float) -> void:
	time = time + delta
	if do_switch and animation_finished:
		global.score = total
		global.switch_scene(next_scene)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'fadeOut':
		animation_finished = true
