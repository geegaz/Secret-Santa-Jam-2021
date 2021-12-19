extends KinematicBody2D

export(NodePath) var health_bar_path: String
onready var _HealthBar: HealthBar = get_node_or_null(health_bar_path)

# Movement variables
var can_move: bool = true
export var max_speed: float = 60 # px/s
export var smooth_speed: float = 12 # 1/x s to max speed

# Dash variables
export var dash_power: float = 300
export var dash_invul: float = 0.25
var can_dash: bool = true
onready var _DashTimer: Timer = $DashTimer

# Damage variables
export var damage_knockback: float = 200
export var damage_invul: float = 1.0
var can_damage: bool = true
onready var _DamageTimer: Timer = $DamageTimer

var invulnerable_time: float = 0

var velocity: Vector2
var dir: Vector2
var last_dir: Vector2

onready var _AnimTree: AnimationTree = $AnimationTree
onready var _Animation: AnimationPlayer = $AnimationPlayer
onready var _StateMachine: AnimationNodeStateMachinePlayback = _AnimTree["parameters/playback"]
onready var _PlayerSprite: Sprite = $PlayerSprite

func _ready():
	if _HealthBar:
		_HealthBar.connect("death",self,"die")
		_HealthBar.show()

func _process(delta: float) -> void:
	# Get input direction
	dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	var state: String = _StateMachine.get_current_node()
	_AnimTree.set("parameters/%s/blend_position"%state, last_dir)
	if dir.length_squared() > 0:
		last_dir = dir
		_PlayerSprite.flip_h = dir.x < 0
		_StateMachine.travel("run")
	else:
		_StateMachine.travel("idle")
	# Reduce invulnerability time
	invulnerable_time = clamp(invulnerable_time - delta, 0, INF)

func _physics_process(delta: float) -> void:
	# Apply velocity
	if can_move:
		velocity = move_and_slide(lerp(velocity, dir * max_speed, delta * smooth_speed))
	if Input.is_action_pressed("ui_select") and can_dash:
		dash()

func dash():
	if !can_dash:
		return
	
	velocity += dir * dash_power
	invulnerable_time += dash_invul
	
	can_dash = false
	
	_DashTimer.start()
	yield(_DashTimer, "timeout")
	
	can_dash = true

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

