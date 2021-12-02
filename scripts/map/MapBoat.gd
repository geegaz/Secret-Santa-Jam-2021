extends KinematicBody2D

export var smooth_speed: float = 8
export var max_speed: float = 30

var dir: Vector2
var velocity: Vector2
var speed_multiplier: float = 1

onready var _BoatMesh: MeshInstance = $Viewport/BoatMesh
onready var _Particles: Particles2D = $Particles2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	_BoatMesh.rotation.y = velocity.angle()

func _physics_process(delta: float) -> void:
	dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = lerp(velocity, dir * max_speed * speed_multiplier, delta * smooth_speed)
	
	if dir.length() > delta:
		_Particles.emitting = true
	else:
		_Particles.emitting = false
	
	move_and_slide(velocity)
