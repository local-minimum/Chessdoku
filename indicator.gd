extends Node2D
class_name RuleIndicator

var _frame: Sprite2D
var _check: Sprite2D

func _ready():
	_frame = find_child("ValidFrame")
	_check = find_child("Valid")
	_frame.modulate = global.tile_tint_white_color
	uncheck()

func check():		
	_check.visible = true
	_frame.visible = true

func uncheck():
	_check.visible = false
	_frame.visible = true
	
func disable():
	_check.visible = false
	_frame.visible = false
