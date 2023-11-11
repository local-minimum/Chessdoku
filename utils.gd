extends Node

func _piece_aggregator(acc: Dictionary, piece: ChessPiece):
	var piece_type = piece.piece_type()
	if acc.has(piece_type):
		acc[piece_type].append(piece.piece_color())
	else:
		acc[piece_type] = [piece.piece_color()]
	return acc

func count_pieces(pieces: Array):
	return pieces.reduce(_piece_aggregator, {})

func extract_piece_positions(position_to_piece: Dictionary, piece_type: global.PIECE):
	return position_to_piece.keys().filter(
		func piece_filter(key: Vector2i):
			var piece: global.PieceSpec = position_to_piece[key]	
			return piece.type == piece_type
	)

func has_line_of_sight_by_piece_rule(
	coordinates: Vector2i,
	piece: global.PieceSpec,
	directions: Array, 
	position_to_piece: Dictionary,
	only_single_step: bool = false,
):
	for direction in directions:
		var check_coords: Vector2i = coordinates + direction
		var collided = false
		while global.on_board(check_coords) and not collided:
			
			if position_to_piece.has(check_coords):
				collided = true
				
				if global.check_piece_rule(piece, position_to_piece[check_coords]):
					return true
			
			if only_single_step:
				break
				
			check_coords += direction

	return false

func get_opponent_pieces_by_line_of_sight(
	coordinates: Vector2i,
	piece: global.PieceSpec,
	directions: Array, 
	position_to_piece: Dictionary,
):
	var pieces: Dictionary = {}
	
	for direction in directions:
		var check_coords: Vector2i = coordinates + direction
		var collided = false
		while global.on_board(check_coords) and not collided:
			
			if position_to_piece.has(check_coords):
				collided = true
				
				if piece.color != position_to_piece[check_coords].color:
					pieces[check_coords] = position_to_piece[check_coords].type
					
				break
				
			check_coords += direction

	return pieces
