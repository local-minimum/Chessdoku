extends Node2D

class_name ChessPiece

const mouse_enter_scale = 1.05
var draggable = false
var dragging = false
var owner_tile: BoardTile
var origin_ref: StaticBody2D
var tween_duration = 0.2
var drag_offset: Vector2

var _piece: global.PieceSpec
var _startScale: Vector2
var _colliding_refs: Array = []
var _prev_colliding_ref: StaticBody2D

func _distance_to_self(a: StaticBody2D, b: StaticBody2D):
	return (global_position - a.global_position).length_squared() < (global_position - b.global_position).length_squared()
	
var colliding_ref: StaticBody2D:
	get:
		if _colliding_refs.size() == 0:
			return null
		_colliding_refs.sort_custom(_distance_to_self)
		return _colliding_refs[0]

func _ready():
	_startScale = scale

func start_drag():
	drag_offset = global_position - get_global_mouse_position()
	global.set_dragged(self)
	dragging = true
	
func end_drag():
	global.clear_dragged(self)
	var col = colliding_ref
	
	if col != null:
		col.occupy(self)
		if owner_tile != null:
			owner_tile.end_occupation(self)
		owner_tile = col
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", col.global_position, tween_duration).set_ease(Tween.EASE_OUT)
	elif owner_tile != null:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", owner_tile.global_position, tween_duration).set_ease(Tween.EASE_OUT)
	elif origin_ref != null:
		origin_ref.reclaim(self)
		
	if col != null:
		col.end_hover()
		
	_colliding_refs.clear()
	dragging = false
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	if draggable:
		if Input.is_action_just_pressed("click"):
			start_drag()
			
	if dragging:
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() + drag_offset
			
		elif Input.is_action_just_released("click"):
			end_drag()
	
	var col = colliding_ref
	if (_prev_colliding_ref != col):
		if (_prev_colliding_ref != null):
			_prev_colliding_ref.end_hover()
		_prev_colliding_ref = col
		if col != null:
			col.begin_hover()
	

func _on_area_2d_mouse_entered():
	if not global.is_dragging && not Input.is_action_pressed("click"):
		draggable = true
		scale = mouse_enter_scale * _startScale

func _on_area_2d_mouse_exited():
	if draggable && not dragging:
		print("Mouse exited")
		draggable = false
		scale = _startScale


func _on_area_2d_body_entered(body: BoardTile):
	if dragging and body.is_in_group("droppable") and body.can_occupy(self):	
		_colliding_refs.append(body)	


func _on_area_2d_body_exited(body):
	if not dragging:
		return
	
	if (colliding_ref == body):
		body.end_hover()
	_colliding_refs.erase(body)


func set_origin(body: StaticBody2D):
	origin_ref = body

func is_origin(body: StaticBody2D):
	return body == origin_ref
	
func recycle():
	if origin_ref != null:
		origin_ref.reclaim(self)
		
func configure(tex: Texture2D, piece: global.PIECE, piece_color: global.PIECE_COLOR):
	var sprite = get_node("Sprite")
	sprite.texture = tex
	sprite.modulate = global.black_color if piece_color == global.PIECE_COLOR.BLACK else global.white_color
	_piece = global.PieceSpec.new(piece, piece_color)
	
func eqaul(other: ChessPiece):
	if other == null:
		return false
	return _piece.color == other._piece.color and _piece.type == other._piece.type

func same_type(other: ChessPiece):
	if other == null:
		return false
	return _piece.type == other._piece.type
