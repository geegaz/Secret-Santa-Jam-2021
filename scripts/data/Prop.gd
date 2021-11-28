class_name Prop

var id: String
var scene_path: String
var size: Vector2

func to_dict() -> Dictionary:
	return {
		"id": id,
		"scene_path": scene_path,
		"size": size
	}

func get_class() -> String:
	return "Prop"
