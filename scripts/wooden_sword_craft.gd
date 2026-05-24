extends Button

@onready var inv: Inv = preload("res://scenes/gui/player_inventory/player_inv.tres")
@onready var slots: Array = $GridContainer.get_children()
const wooden_sword = preload("uid://b72gvccoli5m2")


func _ready() -> void:
	pass # Replace with function body.

func craftWoodSword():
	var wood = load("res://items/wood.tres")

	for slot in slots:
		if slot.get("item") == wood:
			if slot.amount >= 3:
				inv.insert(wooden_sword)
				slot.amount -= 3
				return
	
func _on_pressed() -> void:
	craftWoodSword()
