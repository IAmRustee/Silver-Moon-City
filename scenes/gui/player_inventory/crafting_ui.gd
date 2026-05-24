extends Control

@onready var inv: Inv = preload("res://scenes/gui/player_inventory/player_inv.tres")

var is_open = false

func _ready(): 
	close()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("crafting toggle") or Input.is_action_just_pressed("inventory toggle"):
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
