extends Node2D

var state = "whole"
var player_in_area = false
var cut_hp: int = 10

var silverwood = preload("res://items/silverwood.tscn")
var silverstone = preload("res://items/silverstone.tscn")

@onready var chop: AudioStreamPlayer2D = $StaticBody2D/chop
@onready var fall: AudioStreamPlayer2D = $StaticBody2D/fall

@export var silverwoodItem: InventoryItem
@export var silverstoneItem: InventoryItem

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
				chop.play()
			if Input.is_action_just_pressed("interact") and cut_hp == 0:
				state = "cut"
				chop.play()
				drop_item()

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
		cut_hp = 10

func drop_item():
	var item_instance
	var item
	var drop: int = randi_range(0, 2)
	if drop > 1: 
		item_instance = silverstone.instantiate()
		item = silverstoneItem
	else:
		item_instance = silverwood.instantiate()
		item = silverwoodItem
	item_instance.global_position = $StaticBody2D/Marker2D.global_position
	get_parent().add_child(item_instance)
	player.collect(item)
	await get_tree().create_timer(3).timeout
	$StaticBody2D/growth_timer.start()
