extends Node2D

enum PIECE { PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING }
enum PIECE_COLOR { WHITE, BLACK }

class PieceSpec:
	var type: PIECE
	var color: PIECE_COLOR
	
	func _init(_type: PIECE, _color: PIECE_COLOR):
		self.type = _type
		self.color = _color
		
	func same_type(other: PieceSpec):
		if other == null:
			return false
		return type == other.type

	func equal(other: PieceSpec):
		return color == other.color and type == other.type

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

func on_board(coordinates: Vector2i):
	return coordinates.x >= 1 and coordinates.x <= 12 and coordinates.y >= 1 and coordinates.y <= 12

# Colors
var white_color = Color.ANTIQUE_WHITE
var black_color = Color.DARK_SLATE_GRAY
var tile_tint_white_color = Color(Color.BEIGE, 0.6)
var tile_tint_black_color = Color(Color.DARK_VIOLET, 0.6)

# Assist mode
var show_box_rule_status = true
var show_row_col_rule_status = true

# Rules
enum PIECE_RULE { THREATEN_SAME_TYPE, THREATEN_OPPONENT }
var piece_rule: PIECE_RULE = PIECE_RULE.THREATEN_SAME_TYPE
