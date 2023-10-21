extends Node2D

class_name CDBox

var _tiles = Dictionary()
# Called when the node enters the scene tree for the first time.

	
func _ready():
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


func can_take(piece: ChessPiece, tile: BoardTile):
	var tiles = _tiles.values()

	if tiles.any(func(t: BoardTile): return t.occupant == piece):		
		return true

	return not tiles.any(func(t: BoardTile): return piece.eqaul(t.occupant))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
