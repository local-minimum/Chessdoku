extends StaticBody2D

@export var copies: int = 11
@export var label: Label
@export var template: PackedScene

var hovered = false
var mouse_enter_scale = 1.05
var tween_duration = 0.2

func _ready():
	_sync_label()

func _sync_label():
	label.text = str(copies)

func _process(_delta):
	if hovered:
		if Input.is_action_just_pressed("click"):
			
			copies -= 1
			_sync_label()
			if copies < 1:
				_disabled();
			
			var piece = template.instantiate()
			get_tree().root.add_child(piece)
			piece.set_origin(self)
			piece.global_position = global_position
			piece.start_drag()
			
func _on_area_2d_mouse_entered():
	if copies > 0 and (not global.is_dragging or global.dragged.is_origin(self)):
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

func reclaim(piece: Node2D):
	copies += 1
	if copies > 0:
		_sync_label()
		
	var tween = get_tree().create_tween()
	tween.tween_property(piece, "global_position", global_position, tween_duration).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func (): get_tree().root.remove_child(piece); piece.call_deferred("free"))	
