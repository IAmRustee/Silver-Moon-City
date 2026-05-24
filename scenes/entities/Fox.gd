extends CharacterBody2D

@export var tile_size := 16
@export var move_speed := 130.0

var grid_pos = Vector2i.ZERO
var facing = "F"

var target_position: Vector2
var moving := false

var current_dir = Vector2i.ZERO
var steps_remaining = 0

const DIRECTIONS = [
	Vector2i(1, 0),
	Vector2i(-1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1),

	Vector2i(1, 1),
	Vector2i(-1, -1),
	Vector2i(1, -1),
	Vector2i(-1, 1)
]

@onready var timer = $Timer
@onready var sprite = $AnimatedSprite2D

func _ready():

	grid_pos = Vector2i(position / tile_size)
	target_position = position

	current_dir = get_valid_direction()
	steps_remaining = randi_range(3, 8)

	play_anim("Walk")

func _physics_process(delta):

	position = position.move_toward(
		target_position,
		move_speed * delta
	)

	if position.distance_to(target_position) < 1:

		position = target_position

		if moving:
			moving = false
			random_move()

func _on_timer_timeout():

	if not moving:
		random_move()

func random_move():

	if steps_remaining <= 0:

		current_dir = get_valid_direction()

		# Foxes change direction more often
		steps_remaining = randi_range(3, 8)

	update_facing(current_dir)

	var target = grid_pos + current_dir

	if is_wall(target):

		current_dir = get_valid_direction()
		steps_remaining = randi_range(3, 8)

		random_move()
		return

	# Brief observation pause
	if randi() % 10 == 0:

		play_anim("Idle")

		await get_tree().create_timer(0.2).timeout

	play_anim("Walk")

	grid_pos = target

	target_position = Vector2(grid_pos) * tile_size

	moving = true

	steps_remaining -= 1

func get_valid_direction() -> Vector2i:

	var valid_dirs = []

	for dir in DIRECTIONS:

		if !is_wall(grid_pos + dir):
			valid_dirs.append(dir)

	if valid_dirs.is_empty():
		return Vector2i.ZERO

	return valid_dirs.pick_random()

func update_facing(dir: Vector2i):

	if dir.x > 0:
		facing = "R"

	elif dir.x < 0:
		facing = "L"

	elif dir.y > 0:
		facing = "F"

	elif dir.y < 0:
		facing = "B"

func play_anim(action: String):

	var anim_name = action + " (" + facing + ")"

	if sprite.sprite_frames.has_animation(anim_name):

		if sprite.animation != anim_name:
			sprite.play(anim_name)

func is_wall(pos: Vector2i) -> bool:

	var walls = get_tree().get_first_node_in_group("walls")

	if walls == null:
		return false

	return walls.get_cell_source_id(0, pos) != -1
