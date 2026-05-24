extends Button

@onready var inv: Inv = preload("res://scenes/gui/player_inventory/player_inv.tres")
@onready var slots: Array = $NinePatchRect.get_children()
var wood_amount: int = inv.InventoryItem

func _ready() -> void:
	pass # Replace with function body.

func craftWoodSword(wood_amount):
	pass

func check_wood(inv):
	func insert(item: InventoryItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()
