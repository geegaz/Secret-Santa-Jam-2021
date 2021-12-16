class_name Enemy extends KinematicBody2D

# Part health
export(NodePath) var local_health: NodePath
onready var _LocalHealth: HealthBar = get_node_or_null(local_health)
# Boss health
export(NodePath) var global_health: NodePath
onready var _GlobalHealth: HealthBar = get_node_or_null(global_health)

func _ready() -> void:
	if _LocalHealth:
		_LocalHealth.connect("death", self, "_on_LocalHealth_death")
	if _GlobalHealth:
		_GlobalHealth.connect("death", self, "_on_GlobalHealth_death")

func deal_melee_damage(damage: float, dir: Vector2)->void:
	deal_damage(damage)
	get_tree().call_group("camera", "screenshake", 0.25, 8, dir)

func deal_ranged_damage(damage: float, dir: Vector2)->void:
	deal_damage(damage)
	get_tree().call_group("camera", "screenshake", 0.25, 4, dir)

func deal_damage(damage: float)->void:
	if _LocalHealth:
		_LocalHealth.remove_health(damage)
	if _GlobalHealth:
		_GlobalHealth.remove_health(damage)

func _on_LocalHealth_death() -> void:
	pass

func _on_GlobalHealth_death() -> void:
	pass
