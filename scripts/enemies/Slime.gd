extends KinematicBody2D

enum State {
	IDLE,
	CHASE
}

export var health: float = 10
export var damage: float = 1
export var damage_knockback: float = 200
onready var _DamageTimer = $DamageTimer

export var max_speed: float = 40.0
export var min_speed: float = 20.0
export var detect_distance: float = 70
export var chase_distance: float = 90

var velocity: Vector2 = Vector2.ZERO
var can_see_target: bool = false
var current_state: int = State.IDLE

var target_direction: Vector2 = Vector2.ZERO
var target_distance: float = 0.0

onready var _DetectCast: RayCast2D = $DetectCast
onready var _SlimeSprite: Sprite = $SlimeSprite
onready var _Animation: AnimationPlayer = $AnimationPlayer
onready var _StateMachine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
onready var _Target: Node2D = get_tree().get_nodes_in_group("player").front()

func _physics_process(delta):
	if _Target:
		target_direction = position.direction_to(_Target.position)
		target_distance = position.distance_to(_Target.position)
		# Test if can see player
		_DetectCast.cast_to = target_direction * detect_distance
		can_see_target = (_DetectCast.get_collider() == _Target)
		# Test if can hurt player
		if can_see_target and target_distance < 8:
			_Target.hurt(damage, target_direction)
	
	var target_velocity: Vector2 = Vector2.ZERO
	match _StateMachine.get_current_node():
		"chase":
			target_velocity = target_direction * max_speed
			_SlimeSprite.flip_h = target_direction.x < 0
			
			if target_distance > chase_distance:
				_StateMachine.travel("idle")
		"idle":
			if can_see_target:
				_StateMachine.travel("chase")
			
	velocity = lerp(velocity, target_velocity, 8*delta)
	
	move_and_slide(velocity)

func damage(value: float, dir: Vector2):
	get_tree().call_group("camera", "screenshake", 0.25, 2, dir)
	velocity = dir * damage_knockback
	health -= value
	if health > 0:
		var last_state: String = _StateMachine.get_current_node()
		_StateMachine.start("hurt")
		
		_DamageTimer.start()
		yield(_DamageTimer,"timeout")
		
		_Animation.play("RESET")
		_StateMachine.start(last_state)
	else:
		_StateMachine.start("death")
