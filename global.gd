extends Node2D

enum PIECE { PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING }
enum PIECE_COLOR { WHITE, BLACK }

class PieceSpec:
	var type: PIECE
	var color: PIECE_COLOR
	
	func _init(_type: PIECE, _color: PIECE_COLOR):
		self.type = _type
		self.color = _color

var _drag_piece: Node2D

var is_dragging: bool:
	get:
		return _drag_piece != null

var dragged: Node2D:
	get:
		return _drag_piece		
		
func clear_dragged(piece: Node2D):
	if _drag_piece == piece:
		_drag_piece = null
		
func set_dragged(piece: Node2D):
	if _drag_piece == null:
		_drag_piece = piece

var white_color = Color.ANTIQUE_WHITE
var black_color = Color.DARK_SLATE_GRAY
var tile_tint_white_color = Color(Color.BEIGE, 0.6)
var tile_tint_black_color = Color(Color.DARK_VIOLET, 0.6)
