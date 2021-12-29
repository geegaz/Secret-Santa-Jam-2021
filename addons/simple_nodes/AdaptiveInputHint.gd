class_name AdaptiveInputHint
extends TextureRect

export(Texture) var keyboard_texture
export(Texture) var controller_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event: InputEvent) -> void:
	if controller_texture and event is InputEventJoypadButton or event is InputEventJoypadMotion:
		texture = controller_texture
	elif keyboard_texture and event is InputEventKey or event is InputEventMouse:
		texture = keyboard_texture


