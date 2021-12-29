class_name AdaptiveInputHint
extends TextureRect

export(Texture) var keyboard_texture
export(Texture) var controller_texture

onready var textures = [keyboard_texture, controller_texture]

func _process(delta: float) -> void:
	texture = textures[GameManager.control_mode]


