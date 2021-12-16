extends Camera2D

export(NodePath) var target_path: NodePath
onready var _Target: Node2D = get_node_or_null(target_path)

export var screenshake_influence: Vector2 = Vector2(2.0, 0.25)
var screenshake_intensity: float = 0.0
var screenshake_time: float = 0.0
var screenshake_dir: Vector2 = Vector2.ZERO

var max_screenshake_time: float

func _process(delta):
	if _Target:
		position = _Target.position
	
	if screenshake_time > 0:
		var screenshake_amount = screenshake_time/max_screenshake_time
		offset = screenshake_influence.rotated(screenshake_dir.angle()) * randf() * (screenshake_intensity*screenshake_amount)
		screenshake_time = clamp(screenshake_time - delta, 0, INF)
	else:
		offset = Vector2.ZERO

func screenshake(time: float, intensity: float, dir: Vector2):
	if GameManager.screenshake:
		# set time
		screenshake_time = time
		max_screenshake_time = time
		# set dir & intensity
		screenshake_dir = dir
		screenshake_intensity = intensity
