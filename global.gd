extends Node2D

enum PIECE { PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING }

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
