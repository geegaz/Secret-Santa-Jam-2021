extends Area2D

export var hint_target_time: float = 0.5
var player_inside_ship: bool = false
onready var _Hint: Control = $Hint
onready var _Tween: Tween = $Tween

var hint_time: float = 0

func _ready():
	connect("body_entered",self,"_on_body_inside_ship", [true])
	connect("body_exited",self,"_on_body_inside_ship", [false])

func _process(delta):
	if player_inside_ship:
		hint_time += delta
	else:
		hint_time -= delta
	
	hint_time = clamp(hint_time, 0, hint_target_time)
	_Hint.modulate.a = lerp(0, 1, hint_time/hint_target_time)

func _input(event):
	if event.is_action_pressed("control_interact") and player_inside_ship:
		GameManager.goto_map()

func _on_body_inside_ship(body, inside: bool):
	if body.is_in_group("player"):
		player_inside_ship = inside
