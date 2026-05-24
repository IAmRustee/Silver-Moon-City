extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_text: Label = $CenterContainer/Panel/Label

func update(slot: Inv_Slot):
	if !slot.item: 
		item_visual.visible = true
		amount_text.visible = true
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		amount_text.text = str(slot.amount)
