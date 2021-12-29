extends Node2D

export var island_id: String

func _on_MapTrigger_trigger() -> void:
	GameManager.goto_island(island_id)
