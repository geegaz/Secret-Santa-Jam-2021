extends Node2D

var blocks: Dictionary = {}

onready var _Ship: Node2D = get_parent()
onready var _Floor = $Floor
onready var _Walls = $Walls
onready var _Roof = $Roof

func _ready() -> void:
	pass

func set_block(pos: Vector2, block: ShipBlock) -> void:
	# Using the object itself as a key
	var ids = {
		_Floor: -1,
		_Roof: -1
	}
	if block:
		blocks[pos] = block
		_Floor.tile_set.find_tile_by_name(block.type)
		for tilemap in ids:
			ids[tilemap] = tilemap.tile_set.find_tile_by_name(block.type)
			tilemap.set_cellv(pos, ids[tilemap])
			tilemap.update_bitmask_area(pos)
	else:
		blocks.erase(pos)
		for tilemap in ids:
			tilemap.set_cellv(pos, ids[tilemap])
			tilemap.update_bitmask_area(pos)

func block_below(pos: Vector2) -> ShipBlock:
	# get this level's index
	var level_index = _Ship.levels.find(self)
	if level_index > 0:
		# Try to get the block at the same position on the level below
		var block = _Ship.levels[level_index-1].blocks.get(pos)
		return block
	# Returns null if couldn't find the level in the _Ship, or couldn't find the block below
	return null
	
