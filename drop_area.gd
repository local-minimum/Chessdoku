extends StaticBody2D

@export var overlay: ColorRect
var _occupier: Node2D
var hover_color = Color(Color.MEDIUM_ORCHID, 0.7)
var default_color = Color(Color.SANDY_BROWN, 0.2)

func can_occupy(piece: Node2D):
	return _occupier == null || _occupier.origin_ref != piece.origin_ref
	
func occupy(piece: Node2D):
	if _occupier != null:
		_occupier.recycle()
	_occupier = piece

func end_occupation(piece: Node2D):
	if _occupier == piece:
		_occupier = null

func begin_hover():
	modulate = hover_color
	
func end_hover():
	modulate = default_color
	
# Called when the node enters the scene tree for the first time.
func _ready():
	modulate = default_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if global.is_dragging:
		overlay.visible = true
	else:
		overlay.visible = false
