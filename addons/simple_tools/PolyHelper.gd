class_name PolyHelper

const FILL_VALUE: int = -10
const DIRECTIONS := [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN
]

static func is_valid(pos: Vector2, grid: Array, bounds: Rect2, id):
	return grid[pos.x][pos.y] == id and bounds.has_point(pos)

# Assumes grid is a 2-dimentional array filled with ints
static func flood_fill(start: Vector2, grid: Array, bounds: Rect2, id) -> PoolVector2Array:
	var connected_cells: Array = []
	
	var queue := []
	var pos: Vector2
	var next_pos: Vector2
	
	if is_valid(start, grid, bounds, id):
		queue.append(start)
	
	while queue.size() > 0:
		pos = queue.pop_back()
		connected_cells.append(pos)
		# Test all the connected direction and add them to the queue
		for dir in DIRECTIONS:
			next_pos = pos + dir
			if is_valid(next_pos, grid, bounds, id):
				queue.append(next_pos)
	
	return PoolVector2Array(connected_cells)
