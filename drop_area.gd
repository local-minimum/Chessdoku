extends StaticBody2D

@export var isBlackTile: bool
var _occupier: Node2D
var hover_color = Color(Color.MEDIUM_ORCHID, 0.7)
	
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
	modulate = (
		global.tile_tint_black_color 
		if isBlackTile else global.tile_tint_white_color
	)
	
# Called when the node enters the scene tree for the first time.
func _ready():	
	end_hover()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
