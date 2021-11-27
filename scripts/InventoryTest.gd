extends Control

func _ready() -> void:
	GameManager.inventory.append(GameManager.Item.new("wood","resources",5))
	GameManager.inventory.append(GameManager.Item.new("scrap","resources",1))
	GameManager.inventory.append(GameManager.Item.new("chair","props",2))
	
	GameManager.save_data()
	GameManager.load_data()
	
	print(GameManager.inventory)
