class_name ShipBlock

var type: String
var props: Dictionary

func _init(type: String, props: Dictionary = {}) -> void:
	self.type = type
	self.props = props

func _to_string() -> String:
	return "ShipBlock:[type:%s,props:%s]"%[type,props]

func _to_dict() -> Dictionary:
	return {
		"type": type,
		"props": props
	}
