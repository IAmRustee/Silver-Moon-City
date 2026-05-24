extends CharacterBody2D

@export var tile_size := 16
@export var move_speed := 70.0

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
	steps_remaining = randi_range(2, 4)

	play_anim("Idle")

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

			# Slime occasionally pauses
			if steps_remaining <= 0:

				play_anim("Idle")

				# Slime squish sound
				if not sound.playing:
					sound.play()

				await get_tree().create_timer(
					randf_range(0.4, 0.8)
				).timeout

			random_move()

func random_move():

	if steps_remaining <= 0:

		current_dir = DIRECTIONS.pick_random()

		# Slime changes direction frequently
		steps_remaining = randi_range(2, 4)

	var target = grid_pos + current_dir

	if is_wall(target):

		steps_remaining = 0

		# Wall bump squish
		if randi() % 2 == 0:

			if not sound.playing:
				sound.play()

		random_move()
		return

	# Flip slime
	if current_dir.x > 0:
		sprite.flip_h = false

	elif current_dir.x < 0:
		sprite.flip_h = true

	play_anim("Walk")

	# Occasional movement squish
	if randi() % 6 == 0:

		if not sound.playing:
			sound.play()

	grid_pos = target
	target_position = Vector2(grid_pos) * tile_size

	moving = true

	steps_remaining -= 1

func play_anim(anim_name: String):

	if sprite.sprite_frames.has_animation(anim_name):

		if sprite.animation != anim_name:
			sprite.play(anim_name)

func play_squish():

	if not sound.playing:
		sound.play()

func is_wall(pos: Vector2i) -> bool:

	var walls = get_tree().get_first_node_in_group("walls")

	if walls == null:
		return false

	return walls.get_cell_source_id(pos) != -1
