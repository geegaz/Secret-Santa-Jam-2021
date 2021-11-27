extends Node2D

export var ShipLevel: PackedScene = preload("res://scenes/ship/ShipLevel.tscn")

export var levels_number: int = 2;
export var levels_size: Vector2 = Vector2(4, 3)
export var levels_height: int = 16; # px

var levels: Array

onready var _ShipEditor = $ShipEditor

func _ready() -> void:
	for i in range(levels_number):
		var new_level = ShipLevel.instance()
		new_level.position.y -= i * levels_height
		
		add_child(new_level)
		levels.append(new_level)

func _process(delta: float) -> void:
	pass


func build_at(pos: Vector2) -> void:
	if (pos.x < 0 or pos.y < 0 or pos.x >= levels_size.x or pos.y >= levels_size.y):
		return
	
	var height = get_height_at(pos)
	if height < levels.size():
		levels[height].set_block(pos, ShipBlock.new("wood"))
		print("Build at %s on level %s"%[pos,height])

func destroy_at(pos: Vector2) -> void:
	if (pos.x < 0 or pos.y < 0 or pos.x >= levels_size.x or pos.y >= levels_size.y):
		return
	
	var height = get_height_at(pos)
	if height > 0:
		levels[height-1].set_block(pos, null)
		print("Destroy at %s on level %s"%[pos,height-1])

# Returns the number of blocks stacked at the given position,
# or -1 if the position is outside of the ship's bounds
func get_height_at(pos: Vector2) -> int:
	var height = 0
	while height < levels.size() and levels[height].blocks.has(pos):
		height += 1
	return height

# Returns the children of this node that are in the given group
func get_children_in_group(group: String) -> Array:
	var children_in_group = []
	# Iterate through all children of this node
	for child in get_children():
		if child.is_in_group(group):
			children_in_group.append(child)
	
	return children_in_group
