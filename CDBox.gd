extends Node2D

class_name CDBox

var _puzzle: Puzzle
var _tiles = Dictionary()
var _box_rule_indicator: BoxRuleIndicator
# Called when the node enters the scene tree for the first time.

	
func _ready():
	_puzzle = find_parent("Puzzle")
	_box_rule_indicator = find_child("BoxRuleIndicator")
	var tiles = find_children("Tile *")
	
	var r: RegEx = RegEx.new()
	r.compile("(\\d+)_(\\d+)$")
	
	var accumulator = func _tile_organizer(acc: Dictionary, item: BoardTile):
		var result = r.search(item.name)
		if result:
			var col = int(result.strings[1])
			var row = int(result.strings[2])
			var pos = Vector2i(col, row)
			
			item.box_position = pos
			item.box = self
			
			acc[pos] = item
			
		return acc
		
	_tiles = tiles.reduce(accumulator, {})	
	
func _tile_as_coordinates(tile: BoardTile):
	for key in _tiles:
		if _tiles[key] == tile:
			return key
	return null
	
func _match_rule(piece: ChessPiece, other: ChessPiece, match_type_only: bool):
	if piece == other:
		# This is just the currently dragged piece, we don't care about it
		return false
	elif match_type_only:
		if piece.same_type(other):
			return true
	elif piece.eqaul(other):
			return true
	return false
	
func has_piece_in_row(piece: ChessPiece, row: int, match_type_only: bool = false):
	for col in range(1, 4):
		var tile: BoardTile = _tiles[Vector2i(col, row)]
		if _match_rule(piece, tile.occupant, match_type_only):
			return true
	return false
		
func has_piece_in_col(piece: ChessPiece, col: int, match_type_only: bool = false):
	for row in range(1, 4):
		var tile: BoardTile = _tiles[Vector2i(col, row)]
		if _match_rule(piece, tile.occupant, match_type_only):
			return true
	return false
	
func can_take_box_rules(piece: ChessPiece):
	var tiles = _tiles.values()

	# Box piece rule
	if tiles.any(func(t: BoardTile): return t.occupant == piece):		
		return true

	return not tiles.any(func(t: BoardTile): return piece.eqaul(t.occupant))

func can_take(piece: ChessPiece, tile: BoardTile):
	return (
		can_take_box_rules(piece) and
		_puzzle.can_take_pice(piece, self, _tile_as_coordinates(tile))
	)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func pieces():
	return _tiles.values().map(func extract_occupant(t: BoardTile): return t.occupant).filter(func only_pieces(p: ChessPiece): return p != null)


func validate(tile: BoardTile):
	_box_rule_indicator.validate()
