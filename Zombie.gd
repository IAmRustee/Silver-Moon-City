extends CharacterBody2D

@export var tile_size := 16
@export var move_speed := 40.0

var grid_pos = Vector2i.ZERO
var target_position: Vector2
var moving := false

var current_dir = Vector2i.ZERO
var steps_remaining = 0

const DIRECTIONS = [
	Vector2i(1, 0),
	Vector2i(-1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1)
]

@onready var sprite = $AnimatedSprite2D
@onready var sound = $AudioStreamPlayer2D

func _ready():

	grid_pos = Vector2i(position / tile_size)
	target_position = position

	current_dir = DIRECTIONS.pick_random()
	steps_remaining = randi_range(8, 15)

	play_anim("Walk")

	random_move()

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

func random_move():

	# Keep same direction for several tiles
	if steps_remaining <= 0:

		current_dir = DIRECTIONS.pick_random()
		steps_remaining = randi_range(8, 15)

	var target = grid_pos + current_dir

	# Wall collision
	if is_wall(target):

		steps_remaining = 0

		# Zombie bumps/groans sometimes
		if randi() % 2 == 0:

			if not sound.playing:
				sound.play()

		random_move()
		return

	# Flip sprite left/right
	if current_dir.x > 0:
		sprite.flip_h = false

	elif current_dir.x < 0:
		sprite.flip_h = true

	# Rare zombie pause
	if randi() % 18 == 0:

		play_anim("Idle")

		if not sound.playing:
			sound.play()

		await get_tree().create_timer(0.25).timeout

	play_anim("Walk")

	# Occasional zombie groan while walking
	if randi() % 10 == 0:

		if not sound.playing:
			sound.play()

	grid_pos = target

	target_position = Vector2(grid_pos) * tile_size

	moving = true

	steps_remaining -= 1

func play_anim(anim_name: String):

	if sprite.sprite_frames.has_animation(anim_name):

		# Prevent animation restart spam
		if sprite.animation != anim_name:
			sprite.play(anim_name)

func play_groan():

	if not sound.playing:
		sound.play()

func is_wall(pos: Vector2i) -> bool:

	var walls = get_tree().get_first_node_in_group("walls")

	if walls == null:
		return false

	return walls.get_cell_source_id(pos) != -1
