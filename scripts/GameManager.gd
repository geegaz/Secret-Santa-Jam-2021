extends Node

enum Bonus {
	CANNON,
	WHEELS
}

const MAP: String = "res://scenes/Map.tscn"
const ISLANDS: Dictionary = {
	"start": "res://scenes/Main.tscn"
}

# Save variables
const SAVE_PATH := "res://save.json"

var screenshake: bool = true
var unlocked_bonuses: Array = []
var player_island: String = "start"
var player_position: Vector2
var ship_position: Vector2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

################ Manager Functions ################

func goto_map():
	var player = get_tree().get_nodes_in_group("player").front()
	if player:
		player_position = player.position
	

func goto_island():
	pass

################ Utility Functions ################

# Assumes data is a JSON-compatible object
static func save_data(data, path: String = SAVE_PATH):
	# Prepare json
	var json := JSON.print(data, "    ")
	
	# Save data to file
	var file := File.new()
	file.open(path, File.WRITE)
	file.store_string(json)
	file.close()

# Returns an object, or null if there was an error
static func load_data(path: String = SAVE_PATH):
	# open data from file
	var file := File.new()
	var error := file.open(path, File.READ)
	if error != OK:
		printerr("Could not load file at %s" % SAVE_PATH)
		return null
	
	var json = file.get_as_text()
	var json_result := JSON.parse(json);
	if json_result.error != OK:
		printerr("Error parsing %s: \nline %s: %s"%[SAVE_PATH,json_result.error_line,json_result.error_string])
		return null
	
	file.close()
	return json_result.result

# Reparents node to new_parent, with the option to keep its trandform in the new_parent
static func reparent(node: Node, new_parent: Node, keep_transform: bool = true):
	# TODO: keep_transform
	var old_parent = node.get_parent()
	old_parent.remove_child(node)
	new_parent.add_child(node)

# Returns the children of this node that are in the given group
static func get_children_in_group(node: Node, group: String) -> Array:
	var children_in_group = []
	# Iterate through all children of this node
	for child in node.get_children():
		if child.is_in_group(group):
			children_in_group.append(child)
	
	return children_in_group
