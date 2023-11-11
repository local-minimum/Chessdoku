extends Node2D

class_name PawnRules

func validate_pawn(coordinates: Vector2i, position_to_piece: Dictionary):
	var piece: global.PieceSpec = position_to_piece[coordinates]
	
	if piece.type != global.PIECE.PAWN:
		return

	var take_direction = 1 if piece.color == global.PIECE_COLOR.BLACK else -1
	
	var check_row = coordinates.y + take_direction
	for x_offset in range(-1, 2, 2):
		var take_coordinates = Vector2i(coordinates.x + x_offset, check_row)
		
		if global.on_board(take_coordinates):
			if position_to_piece.has(take_coordinates):
				var other: global.PieceSpec = position_to_piece[take_coordinates]
				
				if global.piece_rule == global.PIECE_RULE.THREATEN_SAME_TYPE:
					if other.type == global.PIECE.PAWN and other.color != piece.color:
						return true
				elif global.piece_rule == global.PIECE_RULE.THREATEN_OPPONENT:
					if other.color != piece.color:
						return true
	
	return false

func validate(
	position_to_piece: Dictionary, 
):
	return position_to_piece.keys().filter(
		func key_filter(key: Vector2i):
			var piece: global.PieceSpec = position_to_piece[key]			
			return piece.type == global.PIECE.PAWN
	).all(
		func passes_rule(key: Vector2i):
			return validate_pawn(key, position_to_piece) == true
	)
