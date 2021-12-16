extends TileSet
tool

export var generate: bool = false setget set_generate
var tile_connections: Dictionary = {
	"grass": [
		"transition",
		
		"floor",
		"metal",
		"tiles",
		"planks",
		"stairs"
	],
	"transition": [
		"air",
		"grass",
		
		"floor",
		"metal",
		"tiles",
		"planks",
		"stairs"
	],
	"sand": [
		"transition",
		
		"floor",
		"metal",
		"tiles",
		"planks",
		"stairs"
	]
	
}
var tiles_mapping: Dictionary

func _is_tile_bound(drawn_id, neighbor_id):
	return (tiles_mapping.has(drawn_id) and neighbor_id in tiles_mapping[drawn_id])

func set_generate(value: bool):
	var new_mapping: = {}
	for tile in tile_connections:
		var id: int = find_tile_by_name(tile)
		for connect_tile in tile_connections[tile]:
			var connect_id: int = find_tile_by_name(connect_tile)
			if new_mapping.has(id):
				new_mapping[id].append(connect_id)
			else:
				new_mapping[id] = [connect_id]
	tiles_mapping = new_mapping
	print("generated %s"%tiles_mapping)
