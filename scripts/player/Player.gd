extends KinematicBody2D

export var max_speed: float = 120 # px/s
export var smooth_speed: float = 12 # 1/x s to max speed

export var dash_power: float = 300
export var dash_cooldown: float = 0.5

var cooldown_time: float = 0

var velocity: Vector2
var dir: Vector2

func _process(delta: float) -> void:
	# Get input direction
	dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	# Reduce dash cooldown
	cooldown_time = clamp(cooldown_time - delta, 0, dash_cooldown)

func _physics_process(delta: float) -> void:
	velocity = lerp(velocity, dir * max_speed, delta * smooth_speed)
	# Apply velocity
	move_and_slide(velocity)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select") and cooldown_time <= 0:
		velocity += dir * dash_power
		cooldown_time = dash_cooldown

