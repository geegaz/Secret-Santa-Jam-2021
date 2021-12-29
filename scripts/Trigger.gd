extends Area2D

signal trigger

export(NodePath) var hint_path: String
onready var _Hint: Control = get_node_or_null(hint_path)

export var hint_appear_time: float = 0.5
var player_inside: bool = false

var hint_time: float = 0

func _ready():
	connect("body_entered",self,"_on_body_inside", [true])
	connect("body_exited",self,"_on_body_inside", [false])

func _process(delta):
	if player_inside:
		hint_time += delta
	else:
		hint_time -= delta
	
	hint_time = clamp(hint_time, 0, hint_appear_time)
	_Hint.modulate.a = lerp(0, 1, hint_time/hint_appear_time)

func _input(event):
	if event.is_action_pressed("control_interact") and player_inside:
		emit_signal("trigger")

func _on_body_inside(body, inside: bool):
	if body.is_in_group("player"):
		player_inside = inside
