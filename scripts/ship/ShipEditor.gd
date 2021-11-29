extends Node2D


export var ShipLevel: PackedScene = preload("res://scenes/ship/ShipLevel.tscn")

export var levels_number: int = 3;
export var levels_height: int = 16; # px
export var levels_size := Vector2(5,3)
export var cell_size := Vector2(32,32)

export var selection_move_speed: float = 0.25; #s
export var selection_move_deadzone: float = 0.8; #s
export var lock_height: bool = true

# Positioning variables
var world_pos := Vector2.ZERO
var block_pos := Vector3.ZERO
# Editing variables
var selection_move_time: float = 0
var last_block_pos: Vector3
var editing_height
# Data variables
var levels: Array
var blocks: Dictionary = {} # uses Vector3 as keys

onready var bounds = Rect2(position, levels_size)
onready var _Ship = get_parent()
onready var _Selection: Sprite = $SelectionSprite
onready var _Helper: Sprite = $SelectionSprite/HelperSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Initialize the levels
	yield(_Ship,"ready")
	for i in range(levels_number):
		var new_level = ShipLevel.instance()
		new_level.position.y -= i * levels_height
		
		levels.append(new_level)
		_Ship.add_child(new_level)

func _process(delta: float) -> void:
	var dir = Vector2(Input.get_axis("ui_left","ui_right"),Input.get_axis("ui_up","ui_down"))
	# Move the selection 
	if dir.length() > selection_move_deadzone:
		selection_move_time += delta
		if selection_move_time >= selection_move_speed:
			world_pos += dir * cell_size
			selection_move_time -= selection_move_speed
			update_selection()
			if Input.is_action_pressed("ship_build") and block_pos.z == editing_height:
				build_at(block_pos)
			elif Input.is_action_pressed("ship_destroy") and block_pos.z == editing_height:
				build_at(block_pos)
	else:
		selection_move_time = selection_move_speed

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		world_pos = get_global_mouse_position()
		update_selection()
		if block_pos != last_block_pos and block_pos.z == editing_height:
			if Input.is_action_pressed("ship_build"):
				build_at(block_pos)
			elif Input.is_action_pressed("ship_destroy"):
				destroy_at(block_pos)
	
	if event.is_action_pressed("ship_build"):
		build_at(block_pos)
		# Start editing
		editing_height = block_pos.z
		update_selection()
	
	if event.is_action_pressed("ship_destroy"):
		destroy_at(block_pos)
		# Start editing
		editing_height = block_pos.z
		update_selection()

################ Building Functions ################

# Position is invalid if:
# - the block is higher than the number of levels / lower than 0
# - the block is outside of the ship's build zone
func is_valid(pos: Vector3) -> bool:
	return !(pos.z >= levels.size() or pos.z < 0 or !bounds.has_point(Vector2(pos.x, pos.y)))

func build_at(pos: Vector3) -> void:
	if is_valid(pos):
		blocks[pos] = Block.new()
		
		var level_pos = Vector2(pos.x, pos.y)
		levels[pos.z].set_walls(level_pos)
		levels[pos.z].set_roof(level_pos)
		if pos.z > 0:
			levels[pos.z-1].set_roof(level_pos, true)
	else:
		printerr("Invalid position %s"%[pos])
	
func destroy_at(pos: Vector3) -> void:
	var destroy_pos := Vector3(pos.x, pos.y, pos.z -1)
	if is_valid(destroy_pos):
		blocks.erase(destroy_pos)
		
		var level_pos = Vector2(destroy_pos.x, destroy_pos.y)
		levels[destroy_pos.z].remove(level_pos)
		if destroy_pos.z > 0:
			levels[destroy_pos.z-1].set_roof(level_pos)
	else:
		printerr("Invalid position %s"%[destroy_pos])

################ Positioning Functions ################

func update_selection() -> void:
	last_block_pos = block_pos
	block_pos = get_world_to_block(world_pos)
	_Selection.position = get_block_to_world(block_pos)
	if is_valid(block_pos):
		_Selection.frame = 0
		_Selection.modulate = Color.white
	else:
		_Selection.frame = 1
		_Selection.modulate = Color.red
	
	_Helper.visible = block_pos.z > 0
	if _Helper.visible:
		_Helper.position.y = block_pos.z * levels_height

# Returns the number of blocks stacked at the given position,
# or -1 if the position is outside of the ship's bounds
func get_height_at(pos: Vector2) -> int:
	var height: int = 0
	while blocks.has(Vector3(pos.x, pos.y, height)):
		height += 1
	return height

# Returns the block at this world position
func get_world_to_block(world_pos: Vector2) -> Vector3:
	var level_pos: Vector2
	
#	var height: int = levels.size() - 1
#	while height >= 0:
#		# Help placing block exactly on the right tile
#		var displacement = Vector2.UP * (height+1) * levels_height
#
#		level_pos = levels[height]._Roof.world_to_map(world_pos - displacement)
#		if blocks.has(Vector3(level_pos.x, level_pos.y, height)):
#			# If aiming inside a column, returns the highest point of that column
#			return Vector3(level_pos.x, level_pos.y, get_height_at(level_pos))
#		height -= 1
	
	# If none of the levels were selected, returns the floor level
	#level_pos = _ShipFloor.world_to_map(world_pos)
	level_pos = transform.scaled(Vector2.ONE / cell_size).xform((world_pos - cell_size/2).snapped(cell_size)) 
	return Vector3(level_pos.x, level_pos.y, get_height_at(level_pos))

# Returns the world position of a block
func get_block_to_world(block_pos: Vector3) -> Vector2:
	var height_ratio: float = levels_height / cell_size.y
	var world_pos: Vector2 = Vector2(block_pos.x, block_pos.y - block_pos.z*height_ratio) * cell_size
	
	return world_pos

################ Utility Functions ################

func load_dict(data: Dictionary) -> int:
	
	return OK

func to_dict() -> Dictionary:
	var data := {
		"levels_number": levels_number,
		"levels_height": levels_height,
		"levels_size": {
			"x": levels_size.x,
			"y": levels_size.y
		}
	}
	
	var block_id: int = 0
	var blocks_data := []
	for block in blocks:
		blocks_data.append({
			"position": {
				"x": block.x,
				"y": block.y,
				"height": block.z
			}
		})
		data["blocks"] = blocks_data
	return data
