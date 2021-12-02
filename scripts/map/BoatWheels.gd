extends Node2D

export var active: bool = true
export var multiplier: float = 2
export(NodePath) var wheels_base_path: String

onready var _MapBoat: Node2D = get_parent()
onready var _WheelsBase: MeshInstance = get_node(wheels_base_path)
onready var _Wheels: Array = _WheelsBase.get_children()

onready var _Particles: Particles2D = $Particles2D

var wheels_speed: float = 0

func _ready() -> void:
	set_active(active)

func _process(delta: float) -> void:
	for wheel in _Wheels:
		wheel.rotate_z(-wheels_speed * delta)
	
	rotation = _MapBoat.velocity.angle()

func _physics_process(delta: float) -> void:
	if active and Input.is_action_pressed("ui_select") and _MapBoat.dir.length() > 0:
		_MapBoat.speed_multiplier = multiplier
		wheels_speed = multiplier * 2
		_Particles.emitting = true
	else:
		_MapBoat.speed_multiplier = 1
		wheels_speed = lerp(wheels_speed, 0, delta * 2)
		_Particles.emitting = false

func set_active(value: bool):
	active = value
	_WheelsBase.visible = value
