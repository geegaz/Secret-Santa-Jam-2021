extends KinematicBody2D

export(NodePath) var health_bar_path: String
onready var _HealthBar: HealthBar = get_node_or_null(health_bar_path)

export var smooth_speed: float = 8
export var speed: float = 30
export var max_speed: float = 60

var dir: Vector2
var velocity: Vector2

onready var _BoatMesh: MeshInstance = $Viewport/BoatMesh
onready var _Animation: AnimationPlayer = $AnimationPlayer
onready var _SplashParticles: Particles2D = $SplashParticles

# Wheels variables
export(NodePath) var fuel_bar_path: String
onready var _FuelBar: TextureProgress = get_node_or_null(fuel_bar_path)

export var has_wheels: bool = false
export var max_fuel_time: float = 3.0
var fuel_time: float = 0
var wheels_active: bool = false
var wheels_speed: float = 0
onready var _SmokeBase: Node2D = $SmokeBase
onready var _SmokeParticles: Particles2D = $SmokeBase/SmokeParticles
onready var _WheelsBase: MeshInstance = $Viewport/BoatMesh/WheelsBase
onready var _Wheels: Array = _WheelsBase.get_children()

# Damage variables
export var damage_invul: float = 1.0
export var damage_knockback: float = 200
var can_damage: bool = true
onready var _DamageTimer: Timer = $DamageTimer

var invulnerable_time: float = 0

func _ready() -> void:
	if GameManager.unlocked_bonuses.has(GameManager.Bonus.WHEELS):
		has_wheels = false
	set_wheels_active(has_wheels)
	
	if _HealthBar:
		_HealthBar.connect("death",self,"die")
		_HealthBar.show()
	
	if GameManager.ship_position:
		position = GameManager.ship_position
	
	update_fuel_bar()

func _process(delta: float) -> void:
	_BoatMesh.rotation.y = velocity.angle()
	_SplashParticles.emitting = dir.length() > 0
	
	if has_wheels:
		# Smoke particles
		_SmokeBase.rotation = velocity.angle()
		_SmokeParticles.emitting = wheels_active
		
		# Wheels animation
		wheels_speed = lerp(wheels_speed, 0, delta * 2)
		if wheels_active:
			wheels_speed = max_speed/speed * 2
		for wheel in _Wheels:
			wheel.rotate_z(-wheels_speed * delta)

func _physics_process(delta: float) -> void:
	dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	wheels_active = false
	var target_speed := speed
	if has_wheels and dir.length() > 0 and Input.is_action_pressed("control_dash"):
		if fuel_time > 0:
			wheels_active = true
			target_speed = max_speed
			fuel_time -= delta
		elif GameManager.inventory[GameManager.Items.WOOD] > 0:
			fuel_time = max_fuel_time
			GameManager.inventory[GameManager.Items.WOOD] -= 1
		
		update_fuel_bar()
	
	velocity = lerp(velocity, dir * target_speed, delta * smooth_speed)
	move_and_slide(velocity)

func set_wheels_active(active: bool):
	has_wheels = active
	_WheelsBase.visible = active
	_SmokeBase.visible = active
	_SmokeParticles.emitting = active

func update_fuel_bar():
	if _FuelBar:
		_FuelBar.value = _FuelBar.max_value * (fuel_time/max_fuel_time)

func hurt(value: float, dir: Vector2 = Vector2.ZERO):
	if !can_damage or invulnerable_time > 0:
		return
	
	invulnerable_time += damage_invul
	velocity = dir*damage_knockback
	if _HealthBar:
		_HealthBar.remove_health(value)
	
	get_tree().call_group("camera", "screenshake", 0.5, 3, dir)
	_Animation.play("hurt")
	can_damage = false
	
	_DamageTimer.start()
	yield(_DamageTimer, "timeout")
	
	can_damage = true
	_Animation.play("RESET")
	

func heal(value: float):
	if _HealthBar:
		_HealthBar.add_health(value)

func die():
	pass

