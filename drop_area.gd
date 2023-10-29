extends StaticBody2D

class_name BoardTile

@export var isBlackTile: bool
var occupant: ChessPiece
var hover_color = Color(Color.MEDIUM_ORCHID, 0.7)
var box_position: Vector2i
var box: CDBox
	
func can_occupy(piece: ChessPiece):
	if occupant != null && occupant == piece:
		return false
	return box.can_take(piece, self)
	
func occupy(piece: ChessPiece):
	if occupant != null:
		occupant.recycle()
	occupant = piece
	box.validate(self)

func end_occupation(piece: ChessPiece):
	if occupant == piece:
		occupant = null
		box.validate(self)

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
