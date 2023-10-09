extends StaticBody2D

@export var copies: int = 11
@export var label: Label

var hovered = false
var mouse_enter_scale = 1.05


func _ready():
	_sync_label()

func _sync_label():
	label.text = str(copies)

func _process(_delta):
	if hovered:
		if Input.is_action_just_pressed("click"):
			copies = copies - 1
			_sync_label()
			if copies < 1:
				_disabled();
	
	


func _on_area_2d_mouse_entered():
	if (copies > 0):
		hovered = true
		scale = Vector2(mouse_enter_scale, mouse_enter_scale)


func _on_area_2d_mouse_exited():
	if (hovered):
		_unhovered();
		
func _disabled():
	copies = 0
	_unhovered()
	
func _unhovered():
	hovered = false
	scale = Vector2.ONE
	_sync_label()
