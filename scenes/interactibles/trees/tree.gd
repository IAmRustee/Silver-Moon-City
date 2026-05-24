extends Node2D

var state = "whole"
var player_in_area = false
var cut_hp: int = 4

var wood = preload("res://items/wood.tscn")

@export var item: InventoryItem
var player = null

func _ready() -> void:
	if state == "cut":
		$growth_timer.start()

func _process(delta: float) -> void:
	if state == "cut":
		$StaticBody2D/AnimatedSprite2D.play("cut")
	if state == "whole":
		$StaticBody2D/AnimatedSprite2D.play("whole")
		if player_in_area: 
			if Input.is_action_just_pressed("interact") and cut_hp > 0:
				cut_hp -= 1
			if Input.is_action_just_pressed("interact") and cut_hp == 0:
				state = "cut"
				drop_wood()

func _on_pickable_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body
		
func _on_pickable_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
		player = null

func _on_growth_timer_timeout() -> void:
	if state == "cut":
		state = "whole"
		cut_hp = 4

func drop_wood():
	var wood_instance = wood.instantiate()
	wood_instance.global_position = $StaticBody2D/Marker2D.global_position
	get_parent().add_child(wood_instance)
	player.collect(item)
	await get_tree().create_timer(3).timeout
	$StaticBody2D/growth_timer.start()
