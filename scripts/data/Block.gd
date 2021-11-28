class_name Block

var props: Array

func _init(props: Array = []) -> void:
	self.props = props

func _to_string() -> String:
	return "Block:[props:%s]"%[props]

func get_class() -> String:
	return "Block"

func to_dict() -> Dictionary:
	return {}
