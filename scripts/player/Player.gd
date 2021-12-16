extends KinematicBody2D

export(NodePath) var health_bar_path: String

export var max_speed: float = 60 # px/s
export var smooth_speed: float = 12 # 1/x s to max speed
export var dash_power: float = 300

export var dash_invul: float = 0.25
export var damage_invul: float = 0.8

export var can_move: bool = true

var can_dash: bool = true
var can_damage: bool = true

var invulnerable_time: float = 0

var velocity: Vector2
var dir: Vector2

onready var _AnimTree: AnimationTree = $AnimationTree
onready var _Animation: AnimationPlayer = $AnimationPlayer
onready var _PlayerSprite: Sprite = $PlayerSprite
var _HealthBar: HealthBar

func _ready():
	_HealthBar = get_tree().get_nodes_in_group("player_health").front()
	if _HealthBar:
		_HealthBar.connect("death",self,"die")
		_HealthBar.show()

func _process(delta: float) -> void:
	# Get input direction
	dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if dir.length_squared() > 0:
		_AnimTree.set("parameters/Idle/blend_position", dir)
		_PlayerSprite.flip_h = dir.x < 0
	# Reduce invulnerability time
	invulnerable_time = clamp(invulnerable_time - delta, 0, INF)

func _physics_process(delta: float) -> void:
	# Apply velocity
	if can_move:
		velocity = move_and_slide(lerp(velocity, dir * max_speed, delta * smooth_speed))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		dash()

func dash():
	if !can_dash:
		return
	
	velocity += dir * dash_power
	invulnerable_time += dash_invul
	
	can_dash = false
	
	var dash_timer = $DashTimer
	dash_timer.start()
	yield(dash_timer, "timeout")
	
	can_dash = true

func hurt(value: float, dir: Vector2 = Vector2.ZERO):
	if !can_damage or invulnerable_time > 0:
		return
	
	invulnerable_time += damage_invul
	velocity += dir*dash_power
	if _HealthBar:
		_HealthBar.remove_health(value)
	
	get_tree().call_group("camera", "screenshake", 0.5, 3, dir)
	_Animation.play("hurt")
	can_damage = false
	
	var damage_timer = $DamageTimer
	damage_timer.start()
	yield(damage_timer, "timeout")
	
	can_damage = true
	_Animation.play("RESET")
	

func heal(value: float):
	if _HealthBar:
		_HealthBar.add_health(value)

func die():
	pass

