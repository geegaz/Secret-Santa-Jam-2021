extends Node

var TestScene = preload("res://scenes/player/Player.tscn")

func _ready() -> void:
	print(TestScene.resource_path)
