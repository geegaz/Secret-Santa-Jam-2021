extends Control

var inventory := []

func _ready() -> void:
	inventory.append(Item.new("wood","resources",5))
	inventory.append(Item.new("scrap","resources",1))
	inventory.append(Item.new("chair","props",2))
	
	GameManager.save_data()
	GameManager.load_data()
	
	print(GameManager.inventory)
