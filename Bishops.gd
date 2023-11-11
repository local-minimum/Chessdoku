extends Node2D
class_name BishopRules

var _rule_indicator: RuleIndicator

func _ready():
	_rule_indicator = get_node("Indicator")
	if global.show_piece_rule_status != true:
		_rule_indicator.disable()

var directions = [Vector2i(-1, -1), Vector2i(1, -1), Vector2i(1, -1), Vector2i(1, 1)]

func validate_bishop(coordinates: Vector2i, position_to_piece: Dictionary):
	var piece: global.PieceSpec = position_to_piece[coordinates]
	
	if piece.type != global.PIECE.BISHOP:
		return

	return PuzzleUtils.has_line_of_sight_by_piece_rule(
		coordinates,
		piece,
		directions,
		position_to_piece,
	)
	
func validate(
	position_to_piece: Dictionary, 
):
	var pieces: Array = PuzzleUtils.extract_piece_positions(position_to_piece, global.PIECE.BISHOP)
	
	var valid = not pieces.is_empty() and pieces.all(
		func passes_rule(key: Vector2i):
			return validate_bishop(key, position_to_piece) == true
	)
	
	if global.show_piece_rule_status:
		if valid:
			_rule_indicator.check()
		else:
			_rule_indicator.uncheck()
	
	return valid
