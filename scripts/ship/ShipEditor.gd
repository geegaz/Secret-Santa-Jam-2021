extends Control

export var tile_size: Vector2 = Vector2(32,32)
onready var _Selection = $SelectionSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("gui_input",self,"on_gui_input")
	connect("mouse_entered",self,"on_mouse_in_editor",[true])
	connect("mouse_exited",self,"on_mouse_in_editor",[false])
	_Selection.hide()

func on_gui_input(event: InputEvent):
	if event is InputEventMouseMotion:
		_Selection.position = (event.position - tile_size/2).snapped(tile_size)
	if event is InputEventMouseButton:
		if event.pressed:
			print("Build at %s"%(_Selection.position/tile_size))

func on_mouse_in_editor(inside: bool):
	_Selection.visible = inside
