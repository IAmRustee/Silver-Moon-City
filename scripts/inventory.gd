extends Resource

class_name Inv

signal update

@export var slots: Array[Inv_Slot]


func insert(item: InventoryItem):

	for slot in slots:

		if slot == null:
			continue

		if slot.item == item:

			slot.amount += 1
			update.emit()
			return


	for slot in slots:

		if slot == null:
			continue

		if slot.item == null:

			slot.item = item
			slot.amount = 1

			update.emit()
			return


func find(item: InventoryItem):

	for i in range(slots.size()):

		var slot = slots[i]

		if slot == null:
			continue

		if slot.item == item:
			return i

	return -1
