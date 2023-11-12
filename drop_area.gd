extends StaticBody2D

class_name BoardTile

@export var isBlackTile: bool
var occupant: ChessPiece
var hover_color = Color(Color.MEDIUM_ORCHID, 0.7)
var box_position: Vector2i
var box: CDBox
var _hint_1: RichTextLabel
var _hint_2: RichTextLabel
var _sprite: Sprite2D
	
func can_occupy(piece: ChessPiece):
	if occupant != null && occupant == piece:
		return false
	return box.can_take(piece, self)
	
func occupy(piece: ChessPiece):
	if occupant != null:
		occupant.recycle()
	occupant = piece
	box.validate(self)

func end_occupation(piece: ChessPiece):
	if occupant == piece:
		occupant = null
		box.validate(self)

func begin_hover():
	_sprite.modulate = hover_color
	
func end_hover():
	_sprite.modulate = (
		global.tile_tint_black_color 
		if isBlackTile else global.tile_tint_white_color
	)
	
# Called when the node enters the scene tree for the first time.
func _ready():	
	_sprite = find_child("Sprite2D")
	_hint_1 = find_child("TextLabel_Lower_Left")
	_hint_1["theme_override_colors/default_color"] = global.black_tile_hint_color  if isBlackTile else global.white_tile_hint_color
	_hint_2 = find_child("TextLabel_Lower_Right")
	_hint_2["theme_override_colors/default_color"] = global.black_tile_hint_color  if isBlackTile else global.white_tile_hint_color		
	end_hover()
	hint("", "")

func hint_number(left: int, right: int):
	hint(str(left), str(right))
	
func hint(left: String, right: String):
	_hint_1.text = left
	_hint_2.text = "[right]%s[/right]" % right
