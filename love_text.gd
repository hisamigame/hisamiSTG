extends Node2D

@export var duration = 0.25
@export var transition = Tween.TRANS_BACK
@export var wait = 0.25
@export var textleft = 'OVER'
@export var textright = 'LOVE'
var margin = 60

var left = -margin
var right = global.field_width + margin



func _ready() -> void:
	var tween = self.create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	var y  = $LabelLeft.position.y
	$LabelLeft/LabelLeft.text = textleft
	$LabelRight/LabelRight.text = textright
	var targetLeft = $LabelLeft.position.x
	var targetRight = $LabelRight.position.x
	
	$LabelLeft.position.x =  left
	$LabelRight.position.x =  right
	
	$LabelLeft/LabelLeft.position.x = -$LabelLeft/LabelLeft.size.x
	$LabelLeft/LabelLeft/Coloring.size.y = $LabelLeft/LabelLeft.size.y
	$LabelRight/LabelRight/Coloring.size.y = $LabelRight/LabelRight.size.y
	
	tween.tween_property($LabelLeft,'position',Vector2(targetLeft,y),duration).set_trans(transition)
	tween.parallel().tween_property($LabelRight,'position',Vector2(targetRight,y),duration).set_trans(transition)
	tween.tween_interval(wait)
	tween.tween_property($LabelLeft,'position',Vector2(left,y),duration).set_trans(transition)
	tween.parallel().tween_property($LabelRight,'position',Vector2(right,y),duration).set_trans(transition)
	tween.tween_callback(queue_free)
