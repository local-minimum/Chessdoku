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
