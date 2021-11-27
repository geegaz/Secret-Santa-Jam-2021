extends Control

func _ready() -> void:
	connect("focus_entered",self,"on_has_focus",[true])
	connect("focus_exited",self,"on_has_focus",[false])

func on_has_focus(focused: bool):
	if focused:
		self_modulate = Color(1.5,1.5,1.5)
	else:
		self_modulate = Color.white
