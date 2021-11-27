extends Node

const SAVE_PATH := "res://save.json"

class Item:
	var id: String
	var category: String
	var amount: int
	
	func _init(id: String, category: String, amount: int) -> void:
		self.id = id
		self.amount = amount
		self.category = category
	
	func _to_string() -> String:
		return "Item:[id:%s,category:%s,amount:%s]"%[id, category, amount]
	
	func _to_dict() -> Dictionary:
		return {
			"id": id,
			"category": category,
			"amount": amount
		}

var inventory: Array = []

func save_data():
	var inventory_data = []
	for item in inventory:
		inventory_data.append(item._to_dict())
	# Prepare json
	var json := JSON.print(inventory_data, "	")
	
	# Save data to file
	var file := File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_string(json)
	file.close()

func load_data():
	# open data from file
	var file := File.new()
	var error := file.open(SAVE_PATH, File.READ)
	if error != OK:
		printerr("Could not load file at %s" % SAVE_PATH)
		return
	
	var json = file.get_as_text()
	var json_result := JSON.parse(json);
	if json_result.error != OK:
		printerr("Error parsing %s: \nline %s: %s"%[SAVE_PATH,json_result.error_line,json_result.error_string])
	else:
		var inventory_data: Array = json_result.result;
		inventory = []
		for item in inventory_data:
			inventory.append(Item.new(item["id"],item["category"],item["amount"]))
	
	file.close()
	
