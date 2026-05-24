extends CharacterBody2D

@export var tile_size := 16
@export var move_speed := 150.0

var grid_pos = Vector2i.ZERO
var facing = "F"

var target_position: Vector2
var moving := false

# Movement memory
var current_dir = Vector2i.ZERO
var steps_remaining = 0

const DIRECTIONS = [
	Vector2i(1, 0),
	Vector2i(-1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1),

	# Diagonals
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

	# Start with a random direction immediately
	current_dir = DIRECTIONS.pick_random()
	steps_remaining = randi_range(6, 12)

	play_anim("Walk")

func _physics_process(delta):

	# Smooth movement
	position = position.move_toward(
		target_position,
		move_speed * delta
	)

	# Reached tile
	if position.distance_to(target_position) < 1:

		position = target_position

		# Continue movement immediately
		if moving:
			moving = false
			random_move()

func _on_timer_timeout():

	# Only start movement if not already moving
	if not moving:
		random_move()

func random_move():

	# Choose new direction after several tiles
	if steps_remaining <= 0:

		current_dir = DIRECTIONS.pick_random()

		# Long movement bursts
		steps_remaining = randi_range(6, 12)

	# Face movement direction
	update_facing(current_dir)

	var target = grid_pos + current_dir

	# Wall collision handling
	if is_wall(target):

		steps_remaining = 0
		random_move()
		return

	# Rare tiny pause
	if randi() % 25 == 0:

		play_anim("Idle")

		await get_tree().create_timer(0.08).timeout

	# Run sometimes
	if randi() % 3 == 0:
		play_anim("Run")
	else:
		play_anim("Walk")

	grid_pos = target

	target_position = Vector2(grid_pos) * tile_size

	moving = true

	steps_remaining -= 1

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

		# Prevent animation restart spam
		if sprite.animation != anim_name:
			sprite.play(anim_name)

func is_wall(pos: Vector2i) -> bool:

	var walls = get_tree().get_first_node_in_group("walls")

	if walls == null:
		return false

	return walls.get_cell_source_id(0, pos) != -1
