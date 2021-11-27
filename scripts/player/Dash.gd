extends Node

export var dash_power: float = 300
export var dash_cooldown: float = 0.5

var cooldown_time: float = 0
var last_dir: Vector2 = Vector2.ZERO

onready var _Player: KinematicBody2D = get_parent()

func _process(delta: float) -> void:
	cooldown_time = clamp(cooldown_time - delta, 0, dash_cooldown)
	if _Player.dir.length_squared() > 0:
		last_dir = _Player.velocity.normalized()

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_select") and cooldown_time <= 0:
		_Player.velocity = last_dir * dash_power
		cooldown_time = dash_cooldown

#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_select") and cooldown_time <= 0:
#		_Player.velocity += last_dir * dash_power
#		cooldown_time = dash_cooldown
