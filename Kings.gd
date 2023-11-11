extends Node2D
class_name KingRules

var _rule_indicator: RuleIndicator

const directions = [
	Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(1, 1),
	Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1),
]

func _ready():
	_rule_indicator = get_node("Indicator")
	if global.show_piece_rule_status != true:
		_rule_indicator.disable()


func _capturable(source: Vector2i, type: global.PIECE, color: global.PIECE_COLOR, target: Vector2i):
	if source == target:
		return false
		
	var delta = source - target
	
	if type == global.PIECE.PAWN:
		if abs(delta.x) == 1 and abs(delta.y) == 1:
			return (delta.y < 0) == (color == global.PIECE_COLOR.WHITE)
		return false

	var x = abs(delta.x)
	var y = abs(delta.y)
		
	if type == global.PIECE.KNIGHT:
		return x == 1 and y == 2 or x == 2 and y == 1
		
	if type == global.PIECE.BISHOP:
		return x == y

	if type == global.PIECE.ROOK:
		return x == 0 or y == 0

	if type == global.PIECE.QUEEN:
		return x == y or x == 0 or y == 0
		
	if type == global.PIECE.KING:
		return x == 1 and y == 1
	
	return false
	
func _position_under_attack(coordinates: Vector2i, piece: global.PieceSpec, position_to_piece: Dictionary):	
	var opponents = PuzzleUtils.get_opponent_pieces_by_line_of_sight(coordinates, piece, directions, position_to_piece)
	var opponent_color = global.PIECE_COLOR.BLACK if piece.color == global.PIECE_COLOR.WHITE else global.PIECE_COLOR.WHITE
	
	for opponent_coords in opponents.keys():
		var opponent: global.PIECE = opponents[opponent_coords]
		if _capturable(opponent_coords, opponent, opponent_color, coordinates):
			return true
			
	return false
	
func validate_king(coordinates: Vector2i, position_to_piece: Dictionary):
	var piece: global.PieceSpec = position_to_piece[coordinates]
	
	if piece.type != global.PIECE.KING:
		return

	# No-one looks at king
	if not _position_under_attack(coordinates, piece, position_to_piece):
		return true
		
	var p2p_without_king = position_to_piece.duplicate()
	p2p_without_king.erase(coordinates)
	
	for direction in directions:
		var escape_position = coordinates + direction
		
		if not global.on_board(escape_position):
			continue
		
		# Position is occupied by own piece
		if position_to_piece.has(escape_position) and position_to_piece[escape_position].color == piece.color:	
			continue
			
		if not _position_under_attack(escape_position, piece, p2p_without_king)	:
			return true

	return false
	
func validate(
	position_to_piece: Dictionary, 
):
	var pieces: Array = PuzzleUtils.extract_piece_positions(position_to_piece, global.PIECE.KING)
	
	var valid = not pieces.is_empty() and pieces.all(
		func passes_rule(key: Vector2i):
			return validate_king(key, position_to_piece) == true
	)
	
	if global.show_piece_rule_status:
		if valid:
			_rule_indicator.check()
		else:
			_rule_indicator.uncheck()
	
	return valid
