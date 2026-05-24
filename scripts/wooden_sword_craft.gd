extends Button

@onready var inv: Inv = preload("res://scenes/gui/player_inventory/player_inv.tres")
@onready var slots = $"../../GridContainer".get_children()

@export var wood: InventoryItem
@export var result: InventoryItem

func craftWoodSword():

	for slot in slots:

		if slot.get("Inv_Slot") != null:

			if slot.Inv_Slot.InventoryItem == wood:

				if slot.Inv_Slot.amount >= 3:

					inv.insert(result)
					slot.Inv_Slot.amount -= 3
					return

func _on_pressed() -> void:
	craftWoodSword()
