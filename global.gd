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
		
	func to_notation():
		if type == PIECE.PAWN:
			return "P" if color == PIECE_COLOR.WHITE else "p"
		if type == PIECE.BISHOP:
			return "B" if color == PIECE_COLOR.WHITE else "b"
		if type == PIECE.KNIGHT:
			return "N" if color == PIECE_COLOR.WHITE else "n"
		if type == PIECE.ROOK:
			return "R" if color == PIECE_COLOR.WHITE else "r"
		if type == PIECE.QUEEN:
			return "Q" if color == PIECE_COLOR.WHITE else "q"
		if type == PIECE.KING:
			return "K" if color == PIECE_COLOR.WHITE else "k"
		return "?"
		
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
var white_tile_hint_color = Color.DARK_VIOLET
var black_tile_hint_color = Color.BEIGE

# Assist mode
var show_box_rule_status = true
var show_row_col_rule_status = true
var show_piece_rule_status = true
var show_tile_hints = true

# Rules
enum PIECE_RULE { THREATEN_SAME_TYPE, THREATEN_OPPONENT }
var piece_rule: PIECE_RULE = PIECE_RULE.THREATEN_OPPONENT


func check_piece_rule(piece: PieceSpec, other: PieceSpec):
	if piece_rule == PIECE_RULE.THREATEN_SAME_TYPE:
		return other.type == piece.type and other.color != piece.color
	elif global.piece_rule == global.PIECE_RULE.THREATEN_OPPONENT:
		return other.color != piece.color
	return false
	
