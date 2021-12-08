extends TileSet
tool

func _is_tile_bound(drawn_id, neighbor_id):
	# Logic: 
	# - a "connecting" tile will connect with any other "connecting" tile
	# - a "sticking" tile will force "connecting" tiles to connect with it
	return (
		(drawn_id == 1 and neighbor_id == 2) or
		(drawn_id == 2 and neighbor_id == 0)
	)
