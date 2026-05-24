extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay

func update(slot: Inv_Slot):
	if !slot.item: 
		item_visual.visible = true
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
