class_name AdaptiveInputHint
extends TextureRect

export(Texture) var keyboard_texture
export(Texture) var controller_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	update_texture()

func _on_joy_connection_changed(device_id, connected):
	update_texture()

func update_texture():
	if Input.get_connected_joypads().size() > 0 and controller_texture:
		texture = controller_texture
	elif keyboard_texture:
		texture = keyboard_texture


