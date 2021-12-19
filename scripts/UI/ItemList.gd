extends VBoxContainer

onready var _ItemsAmount: Dictionary = {
	GameManager.Items.WOOD: $Wood/Amount,
	GameManager.Items.METAL: $Metal/Amount,
	GameManager.Items.SLIME: $Slime/Amount
}
# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("inventory_changed",self,"update_list")
	update_list(GameManager.inventory)

func update_list(inventory):
	for item in inventory:
		_ItemsAmount[item].text = str(inventory[item])
