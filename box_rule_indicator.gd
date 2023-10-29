extends Node2D

class_name BoxRuleIndicator

# Called when the node enters the scene tree for the first time.
var _sprites: Array
var _box: CDBox

func _ready():
	_box = get_parent()
	_sprites = find_children("Corner *")
	var valid = global.show_box_rule_status and _validate_rule()
	for s in _sprites:
		s.visible = valid
	
# Exactly one of each kind in box
func _validate_rule():
	var pieces  = _box.pieces()
	var counter = PuzzleUtils.count_pieces(pieces)
	
	if counter.size() != 6:
		return false
	
	return counter.values().all(func(colors: Array): return colors.size() == 2 and colors[0] != colors[1])

func validate():
	var valid = _validate_rule()
	if global.show_box_rule_status:
		for s in _sprites:
			s.visible = valid
