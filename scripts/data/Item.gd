class_name Item

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

func get_class() -> String:
	return "Item"
