extends Node2D

export var tile_size: Vector2 = Vector2(32,32)

onready var _Ship = get_parent()
onready var _Selection = $SelectionSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_Selection.position = (get_global_mouse_position() - tile_size/2).snapped(tile_size)
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				BUTTON_LEFT:
					_Ship.build_at(_Selection.position/tile_size)
				BUTTON_RIGHT:
					_Ship.destroy_at(_Selection.position/tile_size)
