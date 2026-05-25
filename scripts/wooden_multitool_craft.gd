extends Button

@onready var inv: Inv = preload("res://scenes/gui/player_inventory/player_inv.tres")

@export var wood: InventoryItem
@export var result: InventoryItem

func craftWoodSword(inventory: Inv, ing: InventoryItem, crafted_result: InventoryItem):
	var index = inventory.find(ing)
	if index == -1:
		print("Not found")
		return
	var slot = inventory.slots[index]
	if slot == null:
		print("Slot is null")
		return
	if slot.amount >= 5:
		slot.amount -= 5
		inventory.insert(crafted_result)
		inventory.update.emit()
		print("Crafted")
	else:
		print("Not Enough")

func _on_pressed() -> void:
	craftWoodSword(inv, wood, result)
