extends Node

const SAVE_PATH := "res://save.json"

################ Utility Functions ################

# Assumes data is a JSON-compatible object
func save_data(data, path: String = SAVE_PATH):
	# Prepare json
	var json := JSON.print(data, "    ")
	
	# Save data to file
	var file := File.new()
	file.open(path, File.WRITE)
	file.store_string(json)
	file.close()

# Returns an object, or null if there was an error
func load_data(path: String = SAVE_PATH):
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

static func reparent(node: Node, new_parent: Node, keep_transform: bool = true):
	var old_parent = node.get_parent()
	old_parent.remove_child(node)
	new_parent.add_child(node)
