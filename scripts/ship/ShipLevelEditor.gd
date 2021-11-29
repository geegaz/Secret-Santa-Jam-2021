extends Node2D

const WALLS_DIR := {
	Vector2(0,0): [
		Vector2.LEFT,
		Vector2(-1,-1),
		Vector2.UP
	],
	Vector2(1,0): [
		Vector2.UP
	],
	Vector2(2,0): [
		Vector2.UP,
		Vector2(1,-1),
		Vector2.RIGHT
	],
	Vector2(2,1): [
		Vector2.RIGHT
	],
	Vector2(2,2): [
		Vector2.RIGHT,
		Vector2(1,1),
		Vector2.DOWN
	],
	Vector2(1,2): [
		Vector2.DOWN
	],
	Vector2(0,2): [
		Vector2.DOWN,
		Vector2(-1,1),
		Vector2.LEFT
	],
	Vector2(0,1): [
		Vector2.LEFT
	]
}

export var tile_name := "wood"
export(NodePath) var walls_path: String = "Walls"
export(NodePath) var roof_path: String = "Roof"

onready var _Walls: TileMap = get_node_or_null(walls_path)
onready var _Roof: TileMap = get_node_or_null(roof_path)

var ids := {}

func _ready() -> void:
	# Associate all the tilemaps's ids to their tile names in a dictionary
	for tilemap in [_Walls, _Roof]:
		var tileset: TileSet = tilemap.tile_set
		var temp_ids := {}
		for tile_id in tileset.get_tiles_ids():
			var tile_name: String = tileset.tile_get_name(tile_id)
			temp_ids[tile_name] = tile_id
		ids[tilemap] = temp_ids

################ Building Functions ################

func set_roof(pos: Vector2, is_floor: bool = false) -> void:
	var new_tile: int = ids[_Roof].get(tile_name, -1)
	if is_floor:
		new_tile = ids[_Roof].get(tile_name+"_floor", -1)
		
	# Set roof
	_Roof.set_cellv(pos, new_tile)
	_Roof.update_bitmask_area(pos)

func set_walls(pos: Vector2) -> void:
	# Set walls
	var wall_pos: Vector2 = pos * 2
	var wall_sides = get_wall_sides()
	for dir in WALLS_DIR:
		# Check each of the tiles that make the wall to create it
		var new_tile: int = ids[_Walls].get(tile_name, -1)
		if dir in wall_sides:
			var check_dir = WALLS_DIR[dir].front()
			# If this wall tile is an edge of the tile at pos, it should delete itself 
			# if there's a tile beside it, so there's no walls inside the rooms
			if _Roof.get_cellv(pos+check_dir) >= 0:
				new_tile = -1
		
		_Walls.set_cellv(wall_pos+dir, new_tile)
		_Walls.update_bitmask_area(wall_pos+dir)

func remove(pos: Vector2) -> void:
	# Remove roof
	_Roof.set_cellv(pos, -1)
	_Roof.update_bitmask_area(pos)
	
	# Remove wall
	var wall_pos: Vector2 = pos * 2
	for dir in WALLS_DIR:
		# Check each of the tiles making the wall to remove or update them
		var new_tile := -1
		for check_dir in WALLS_DIR[dir]:
			# If there's a tile in any of these directions from pos,
			# it should place a wall there to ensure there are no "leaking" rooms
			if _Roof.get_cellv(pos+check_dir) >= 0:
				new_tile = ids[_Walls].get(tile_name, -1)
				break # skip unnecessary iterations
		
		_Walls.set_cellv(wall_pos+dir, new_tile)
		_Walls.update_bitmask_area(wall_pos+dir)

################ Utility Functions ################

# Returns the wall tiles that are not corners (and so check for a single adjacent tile)
func get_wall_sides() -> Array:
	var sides := []
	for dir in WALLS_DIR:
		if WALLS_DIR[dir].size() == 1:
			sides.append(dir)
	return sides
