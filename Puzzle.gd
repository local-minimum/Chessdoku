extends Node2D

class_name Puzzle

var _boxes = Dictionary()
var _row_rules: Array
var _col_rules: Array

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
	
func can_take_piece_in_row(piece: ChessPiece, box: CDBox, box_row: int, match_only_type: bool = false):
	var box_coords = _box_as_coordinates(box)
	for col in range(1, 4):
		var b: CDBox = _boxes[Vector2i(col, box_coords.y)]
		if b.has_piece_in_row(piece, box_row, match_only_type):
			return false
	return true
	
func can_take_piece_in_col(piece: ChessPiece, box: CDBox, box_col: int, match_only_type: bool = false):
	var box_coords = _box_as_coordinates(box)
	for row in range(1, 4):
		var b: CDBox = _boxes[Vector2i(box_coords.x, row)]
		if b.has_piece_in_col(piece, box_col, match_only_type):
			return false
	return true
	
func can_take_pice(piece: ChessPiece, box: CDBox, internal_coords: Vector2i):
	return (
		can_take_piece_in_row(piece, box, internal_coords.y) 
		and can_take_piece_in_col(piece, box, internal_coords.x)
	)

func get_piece(coords: Vector2i):
	var box_coords = Vector2i((coords.x - 1) / 4 + 1, (coords.y - 1) / 4 + 1)
	if _boxes == null or not _boxes.has(box_coords):
		return null
		
	var box = _boxes[box_coords]
	
	var internal_coords = Vector2i(coords.x - (box_coords.x - 1) * 4, coords.y - (box_coords.y - 1) * 4)
	return box.get_piece(internal_coords)

var _numbers =  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

func row_pieces(row: int):	
	return _numbers.map(func piece_getter(n): return get_piece(Vector2i(n, row))).filter(func not_null(v): return v != null)

func col_pieces(col: int):	
	return _numbers.map(func piece_getter(n): return get_piece(Vector2i(col, n))).filter(func not_null(v): return v != null)

func validate(box: CDBox, coordinates: Vector2i):
	var box_coords = _box_as_coordinates(box)
	
	var row = (box_coords.y - 1) * 4 + coordinates.y
	_row_rules[row - 1].validate()
	
	var col = (box_coords.x - 1) * 4 + coordinates.x
	_col_rules[col - 1].validate()
