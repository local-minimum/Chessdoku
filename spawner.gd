extends StaticBody2D

@export var template: PackedScene
@export var pieceType: global.PIECE
@export var pieceColor: global.PIECE_COLOR
@export var tex: Texture2D

var label: Label
var hovered = false
var mouse_enter_scale = 1.05
var tween_duration = 0.2
var img: Sprite2D
var start_scale: Vector2
var _copies: int = 12

func _ready():		
	start_scale = scale
	label = get_node("Label")
	img = get_node("TemplateImage")	
	img.texture = tex
	img.modulate = global.black_color if pieceColor == global.PIECE_COLOR.BLACK else global.white_color
	_sync_label()

func _sync_label():
	label.text = str(_copies)

func _process(_delta):
	if hovered:
		if Input.is_action_just_pressed("click"):
			
			_copies -= 1
			_sync_label()
			if _copies < 1:
				_disabled();
			
			var piece = template.instantiate()
			get_tree().root.add_child(piece)
			piece.set_origin(self)
			piece.global_position = global_position
			piece.configure(img.texture, pieceType, pieceColor)
			piece.start_drag()
			
func _on_area_2d_mouse_entered():
	if _copies > 0 and (not global.is_dragging or global.dragged.is_origin(self)):
		hovered = true
		scale = start_scale * mouse_enter_scale

func _on_area_2d_mouse_exited():
	if (hovered):
		_unhovered();
		
func _disabled():
	_copies = 0
	_unhovered()
	_sync_label()
	
func _unhovered():
	hovered = false
	scale = start_scale	

func reclaim(piece: Node2D):
	_copies += 1
	if _copies > 0:
		_sync_label()
		
	var tween = get_tree().create_tween()
	tween.tween_property(piece, "global_position", global_position, tween_duration).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func (): get_tree().root.remove_child(piece); piece.call_deferred("free"))	
