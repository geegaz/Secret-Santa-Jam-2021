extends Node2D

onready var _WheelsBase: Node2D = $WheelsBase
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_WheelsBase.visible = GameManager.unlocked_bonuses.has(GameManager.Bonus.WHEELS)

func _on_ShipTrigger_trigger() -> void:
	GameManager.goto_map()
