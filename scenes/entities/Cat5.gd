extends CharacterBody2D

@export var tile_size := 16
@export var move_delay := 1.5

var grid_pos: Vector2i

const DIRECTIONS = [
	Vector2i(1,0),
	Vector2i(-1,0),
	Vector2i(0,1),
	Vector2i(0,-1),
	Vector2i(1,1),
	Vector2i(-1,-1),
	Vector2i(1,-1),
	Vector2i(-1,1)
]

@onready var timer = $Timer

func _ready():
	grid_pos = Vector2i.ZERO
	position = grid_pos * tile_size

func _on_timer_timeout():
	random_move()

func random_move():
	
	if randi() % 2 == 0:
		$AnimatedSprite2D.play("idle")
		return
		
	$AnimatedSprite2D.play("walk")
		
	var preferred_dirs = [
		Vector2i(1,0),
		Vector2i(-1,0),
		Vector2i(1,0),
		Vector2i(-1,0),
		Vector2i(0,1),
		Vector2i(0,-1)
	]

	var dir = preferred_dirs.pick_random()
	
	var target = grid_pos + dir

	if is_wall(target):
		return

	grid_pos = target
	position = grid_pos * tile_size

func is_wall(pos: Vector2i) -> bool:
	var walls = get_tree().get_first_node_in_group("walls")

	if walls == null:
		return false

	return walls.get_cell_source_id(0, pos) != -1
