extends KinematicBody2D

enum State {
	IDLE,
	CHASE
}

export var health: float = 3.0

export var damage: float = 1.0
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
onready var _StateMachine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
onready var _Target: Node2D = get_tree().get_nodes_in_group("player").front()

func _physics_process(delta):
	if _Target:
		target_direction = position.direction_to(_Target.position)
		target_distance = position.distance_to(_Target.position)
		_DetectCast.cast_to = target_direction * detect_distance
		can_see_target = (_DetectCast.get_collider() == _Target)
	
	if can_see_target:
		_StateMachine.travel("chase")
		_SlimeSprite.flip_h = target_direction.x < 0
	elif target_distance > chase_distance:
		_StateMachine.travel("idle")
	
	match _StateMachine.get_current_node():
		"chase":
			velocity = target_direction * max_speed
		_:
			velocity = Vector2.ZERO
	
	move_and_slide(velocity)
	for i in get_slide_count():
		var body = get_slide_collision(i).collider
		if body.is_in_group("player"):
			body.hurt(damage, position.direction_to(body.position))

func damage(value: float, dir: Vector2):
	get_tree().call_group("camera", "screenshake", 0.25, 2, dir)
	var hurt_timer = $Timer
	
	hurt_timer.start()
	_StateMachine.start("hurt")
	yield(hurt_timer,"timeout")
	_StateMachine.start("RESET")
