extends Node2D

class_name Puzzle

var _boxes = Dictionary()

# Called when the node enters the scene tree for the first time.
func _ready():
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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
