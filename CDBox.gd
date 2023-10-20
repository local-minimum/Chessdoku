extends Node2D

var _tiles = Dictionary()
# Called when the node enters the scene tree for the first time.

	
func _ready():
	var tiles = find_children("Tile *")
	
	var r: RegEx = RegEx.new()
	r.compile("(\\d+)_(\\d+)$")
	
	var accumulator = func _tile_organizer(acc: Dictionary, item: Node2D):
		var result = r.search(item.name)
		if result:
			var col = int(result.strings[1])
			var row = int(result.strings[2])
			var pos = Vector2i(col, row)
			
			acc[pos] = item
		
		return acc
		
	_tiles = tiles.reduce(accumulator, {})	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
