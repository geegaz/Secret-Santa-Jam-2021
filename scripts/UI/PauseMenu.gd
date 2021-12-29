extends ColorRect

onready var _Buttons = {
	"continue": $Pause/Buttons/Continue,
	"options": $Pause/Buttons/Options,
	"options-back": $Options/Label/Back,
	"menu": $Pause/Buttons/Menu
}
onready var _Pause = $Pause
onready var _Options = $Options
var current_menu: Control

onready var _Tween: Tween = $Tween

func _ready():
	current_menu = _Options
	change_menu_to(_Pause)
	
	pause(get_tree().paused)
	
	_Buttons["continue"].connect("pressed",self,"pause",[false])
	_Buttons["options"].connect("pressed",self,"change_menu_to",[_Options])
	_Buttons["options-back"].connect("pressed",self,"change_menu_to",[_Pause])

func _input(event):
	if event.is_action_pressed("control_pause") and current_menu == _Pause:
		pause(!get_tree().paused)
		change_menu_to(_Pause)
	
	elif event.is_action_pressed("ui_cancel") and visible:
		if current_menu == _Pause:
			pause(false)
		else:
			change_menu_to(_Pause)

func change_menu_to(next_menu: Control):
	next_menu.show()
	if current_menu and current_menu != next_menu:
		current_menu.hide()
	
	current_menu = next_menu
	match next_menu:
		_Pause:
			_Buttons["continue"].grab_focus()
		_Options:
			_Buttons["options-back"].grab_focus()

func pause(value: bool):
	get_tree().paused = value
	visible = value
