extends Path2D

export(NodePath) var boat_path: String = "../BoatSprite"
onready var _Boat: Node2D = get_node_or_null(boat_path)

export var travelling_speed: float = 20 # px/s

onready var _MapTravel: PathFollow2D = $MapTravel
onready var _MapLine: Line2D = $MapLine
onready var _Flag: Node2D = $FlagSprite

var travelling := false
var world_pos: Vector2
var flags: Array

func _ready() -> void:
	stop_travelling()

func _process(delta: float) -> void:
	if travelling:
		_MapTravel.offset += travelling_speed * delta
		# Boat appearance
		_Boat.position = _MapTravel.position
		_Boat.frame = round(abs((_MapTravel.rotation_degrees + 90) / 45.0))
		_Boat.flip_h = (_MapTravel.rotation_degrees + 90) < 0
		
		# Reached the end ?
		if _MapTravel.unit_offset >= 1:
			stop_travelling()
	else:
		_Flag.position = world_pos

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		world_pos = get_global_mouse_position()
	
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_LEFT:
				if event.pressed and !travelling:
					add_travel_point(world_pos)
	
	if event.is_action_pressed("ui_accept"):
		start_travelling()
	
	if event.is_action_pressed("ui_cancel"):
		stop_travelling()

func add_travel_point(pos: Vector2) -> void:
	if curve.get_point_count() > 0:
		var new_flag = _Flag.duplicate()
		new_flag.position = pos
		add_child(new_flag)
		flags.append(new_flag)
	
	curve.add_point(pos)
	_MapLine.add_point(pos)

func clear_travel_points() -> void:
	for flag in flags:
		flag.queue_free()
	flags.clear()
	
	curve.clear_points()
	_MapLine.clear_points()

func start_travelling() -> void:
	travelling = true
	_Flag.hide()
	_MapTravel.offset = 0

func stop_travelling() -> void:
	travelling = false
	_Flag.show()
	clear_travel_points()
	add_travel_point(_Boat.position)
