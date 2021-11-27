extends KinematicBody2D

export var max_speed: float = 120 # px/s
export var smooth_speed: float = 12 # 1/x s to max speed

var velocity: Vector2
var dir: Vector2

func _process(delta: float) -> void:
	dir = Vector2(Input.get_axis("ui_left","ui_right"),Input.get_axis("ui_up","ui_down")).normalized()

func _physics_process(delta: float) -> void:
	velocity = lerp(velocity, dir * max_speed, delta * smooth_speed)
	
	move_and_slide(velocity)

