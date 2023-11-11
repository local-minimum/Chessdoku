extends Node2D

class_name PawnRules

var _rule_indicator: RuleIndicator

func _ready():
	_rule_indicator = get_node("Indicator")
	if global.show_piece_rule_status != true:
		_rule_indicator.disable()
	
func validate_pawn(coordinates: Vector2i, position_to_piece: Dictionary):
	var piece: global.PieceSpec = position_to_piece[coordinates]
	
	if piece.type != global.PIECE.PAWN:
		return

	var take_direction = 1 if piece.color == global.PIECE_COLOR.BLACK else -1
	
	var check_row = coordinates.y + take_direction
	for x_offset in range(-1, 2, 2):
		var take_coordinates = Vector2i(coordinates.x + x_offset, check_row)
		
		if global.on_board(take_coordinates):
			if position_to_piece.has(take_coordinates):
				if global.check_piece_rule(piece, position_to_piece[take_coordinates]):
					return true
	
	return false

func validate(
	position_to_piece: Dictionary, 
):
	var pieces: Array = PuzzleUtils.extract_piece_positions(position_to_piece, global.PIECE.PAWN)
	
	var valid = not pieces.is_empty() and pieces.all(
		func passes_rule(key: Vector2i):
			return validate_pawn(key, position_to_piece) == true
	)
	
	if global.show_piece_rule_status:
		if valid:
			_rule_indicator.check()
		else:
			_rule_indicator.uncheck()
	
	return valid
