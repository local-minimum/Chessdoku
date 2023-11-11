extends Node2D

class_name RowColRowIndicator

enum Direction { Row, Column }

@export
var number: int
@export
var direction: Direction

var _puzzle: Puzzle
var _frame: Sprite2D
var _check: Sprite2D

func _ready():
	_puzzle = find_parent("Puzzle")
	_frame = find_child("ValidFrame")
	_check = find_child("Valid")
	_frame.modulate = global.tile_tint_white_color
	
	var valid = global.show_row_col_rule_status and _validate_rule()	
	_frame.visible = global.show_row_col_rule_status
	_check.visible = valid
		
func _get_pieces():
	if direction == Direction.Row:
		return _puzzle.row_pieces(number)	
	return _puzzle.col_pieces(number)

# Rule says there should be at least one of each type in each row and
# no exact duplicate pieces
func _validate_rule():
	var counts: Dictionary = PuzzleUtils.count_pieces(_get_pieces())
	if counts.size() != 6:
		return false
		
	return counts.values().all(func (colors): return colors.size() == 2 and colors[0] != colors[1] or colors.size() == 1)

var _valid: bool = false

func validate():
	_valid = _validate_rule()
	_check.visible = _valid
	return _valid
	
func valid():
	return _valid
