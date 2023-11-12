extends Node2D

class_name Puzzle

var _boxes = Dictionary()
var _row_rules: Array
var _col_rules: Array
var _white_spawners: Array
var _black_spawners: Array

func _config_boxes():
	var boxes = find_children("Box *")
	
	var r: RegEx = RegEx.new()
	r.compile("Box (\\d+)$")

	var accumulator = func _box_organizer(acc: Dictionary, item: CDBox):
		var result = r.search(item.name)
		if result:
			var number = int(result.strings[1])
			
			acc[_box_number_as_coordinates(number)] = item
			
		return acc	
				
	_boxes = boxes.reduce(accumulator, {})

func _gather_row_col_rules(pattern: String):
	var rules = find_children(pattern)
	var arr = Array()
	arr.resize(12)
	for rule in rules:
		arr[rule.number - 1] = rule
	return arr
	
func _config_row_rules():
	_row_rules = _gather_row_col_rules("RowRuleIndicator *")
	
func _config_col_rules():
	_col_rules = _gather_row_col_rules("ColRuleIndicator *")
		
func _ready():
	_white_spawners = find_child("White Spawners").find_children("* Spawner")
	_black_spawners = find_child("Black Spawners").find_children("* Spawner")
	_config_boxes()
	_config_row_rules()
	_config_col_rules()
	
func _box_number_as_coordinates(number: int):
	var col = (number - 1) % 3 + 1
	var row = (number - 1) / 3 + 1
	return Vector2i(col, row)
	
func _box_as_coordinates(box: CDBox):
	for key in _boxes.keys():
		if _boxes[key] == box:
			return key
	return null	
	
func _box_internal_coordinates_to_coordinates(box: CDBox, internal_coords: Vector2i):
	return (_box_as_coordinates(box) - Vector2i(1, 1)) * 4 + internal_coords
	
func can_accept_piece_in_row(piece: ChessPiece, box: CDBox, box_row: int, match_only_type: bool = false):
	var box_coords = _box_as_coordinates(box)
	for col in range(1, 4):
		var b: CDBox = _boxes[Vector2i(col, box_coords.y)]
		if b.has_piece_in_row(piece, box_row, match_only_type):
			return false
	return true
	
func can_accept_piece_in_col(piece: ChessPiece, box: CDBox, box_col: int, match_only_type: bool = false):
	var box_coords = _box_as_coordinates(box)
	for row in range(1, 4):
		var b: CDBox = _boxes[Vector2i(box_coords.x, row)]
		if b.has_piece_in_col(piece, box_col, match_only_type):
			return false
	return true
	
func can_accept_king(piece: ChessPiece, box: CDBox, internal_coords: Vector2i):
	if piece.piece_type() != global.PIECE.KING:
		return true
		
	var _position = _box_internal_coordinates_to_coordinates(box, internal_coords)
	
	# print("---", _position)
	for offset in KingRules.directions:
		var check_position = _position + offset
		
		if not global.on_board(check_position):
			# print("Off board", check_position)
			continue
			
		var check_piece: ChessPiece = get_piece(check_position)
		if check_piece == null:
			# print("No piece", check_position)
			continue
			
		if (
			check_piece.piece_color() != piece.piece_color() 
			and check_piece.piece_type() == global.PIECE.KING
		):
			# print("Illegal king", check_position)
			return false
	return true
	
func can_take_pice(piece: ChessPiece, box: CDBox, internal_coords: Vector2i):	
	return (
		can_accept_piece_in_row(piece, box, internal_coords.y) 
		and can_accept_piece_in_col(piece, box, internal_coords.x)
		and can_accept_king(piece, box, internal_coords)
	)

func get_piece(coords: Vector2i):
	var box_coords = Vector2i((coords.x - 1) / 4 + 1, (coords.y - 1) / 4 + 1)
	if _boxes == null or not _boxes.has(box_coords):
		return null
		
	var box = _boxes[box_coords]
	
	var internal_coords = Vector2i(coords.x - (box_coords.x - 1) * 4, coords.y - (box_coords.y - 1) * 4)
	return box.get_piece(internal_coords)

func get_tile(coords: Vector2i):
	var box_coords = Vector2i((coords.x - 1) / 4 + 1, (coords.y - 1) / 4 + 1)
	if _boxes == null or not _boxes.has(box_coords):
		return null
		
	var box = _boxes[box_coords]
	
	var internal_coords = Vector2i(coords.x - (box_coords.x - 1) * 4, coords.y - (box_coords.y - 1) * 4)
	return box.get_tile(internal_coords)

var _numbers =  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

func row_pieces(row: int):	
	return _numbers.map(func piece_getter(n): return get_piece(Vector2i(n, row))).filter(func not_null(v): return v != null)

func col_pieces(col: int):	
	return _numbers.map(func piece_getter(n): return get_piece(Vector2i(col, n))).filter(func not_null(v): return v != null)

func get_pieces():
	var position_to_piece: Dictionary = {}
	
	for row in _numbers:
		for col in _numbers:
			var coords = Vector2i(col, row)
			var piece: ChessPiece = get_piece(coords)
			if piece != null:
				var spec = piece.spec()
				position_to_piece[coords] = spec
									
	return position_to_piece
	
func board_to_string():
	var line: String = ""
	for row in _numbers:
		for col in _numbers:
			var coords = Vector2i(col, row)
			var piece: ChessPiece = get_piece(coords)
			if piece == null:
				line += "."
			else:
				line += piece.spec().to_notation()
		line += "\n"
	return line

@export var _pawn_rules: PawnRules
@export var _rook_rules: RookRules
@export var _bishop_rules: BishopRules
@export var _knight_rules: HorseRules
@export var _queen_rules: QueenRules
@export var _king_rules: KingRules

func validate_capture_rules():
	var position_to_piece = get_pieces()
	
	var p_rule = _pawn_rules.validate(position_to_piece)
	var r_rule = _rook_rules.validate(position_to_piece)
	var b_rule = _bishop_rules.validate(position_to_piece)
	var kn_rule = _knight_rules.validate(position_to_piece)
	var q_rule = _queen_rules.validate(position_to_piece)
	var k_rule = _king_rules.validate(position_to_piece)
	
	return p_rule and r_rule and b_rule and kn_rule and q_rule and k_rule

# TODO:
# 1. _validate should validate based on a position_to_pieces
# 2. means box and row/col rules need restructuring
# 3. this should just be validate()
func validate(box: CDBox, coordinates: Vector2i):
	var box_coords = _box_as_coordinates(box)
	
	var row = (box_coords.y - 1) * 4 + coordinates.y
	_row_rules[row - 1].validate()
	
	var col = (box_coords.x - 1) * 4 + coordinates.x
	_col_rules[col - 1].validate()
	
	var c_rules = _col_rules.all(func check_valid(rule: RowColRowIndicator): rule.valid())
	var r_rules = _row_rules.all(func check_valid(rule: RowColRowIndicator): rule.valid())	
	var p_rules = validate_capture_rules()
	var b_rules = _boxes.values().all(func check_valid_box(box: CDBox): box.valid())
	var s_rules = (_white_spawners + _black_spawners).all(func check_valid_spawners(spawner: PieceSpawner): spawner.valid())
		
	if c_rules and r_rules and p_rules and b_rules and s_rules:
		# TODO: Handle winning!?
		print("Made it!")
		
	_set_hints()

func _spawners_with_remaining(piece_color: global.PIECE_COLOR):
	var pieces = []
	var _spawners = _white_spawners if piece_color == global.PIECE_COLOR.WHITE else _black_spawners
	for spawner in _spawners:
		if spawner.remainging():
			pieces.append(spawner.pieceType)

	return pieces
	
func _set_hints():
	var blacks = _spawners_with_remaining(global.PIECE_COLOR.BLACK)
	var whites = _spawners_with_remaining(global.PIECE_COLOR.WHITE)
	
	for row in _numbers:
		for col in _numbers:
			var coords = Vector2i(col, row)
			var tile: BoardTile = get_tile(coords)
			
			if not global.show_tile_hints:
				tile.hint("", "")
				continue

			# TODO: Acutally check if occupant follows all rules
			if tile.occupant != null:
				tile.hint("", "")
				continue

			# TODO: Actually check how many of remaining pieces are allowed
			tile.hint_number(whites.size(), blacks.size())
