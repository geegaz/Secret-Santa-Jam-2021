extends Node2D

export(NodePath) var player_path: String
onready var _Player: Node2D = get_node_or_null(player_path)

func _process(delta):
	if _Player:
		position = _Player.position
