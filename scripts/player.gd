extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $Sprite2D/AnimationPlayer

@export var inventory: Inv

const maxSpeed: int = 120
const acceleration: int = 5
const friction: int = 8

# NEW
var attacking := false
var facing := "down"

func _physics_process(delta: float) -> void:

	# Left click attack
	if Input.is_action_just_pressed("left_click") and not attacking:
		attack()

	var input = Vector2.ZERO

	# Disable movement while attacking
	if not attacking:
		input = Vector2(
			Input.get_action_strength("d") - Input.get_action_strength("a"),
			Input.get_action_strength("s") - Input.get_action_strength("w")
		).normalized()

	# Movement animations
	if Input.get_action_strength("d") or Input.get_action_strength("a"):

		facing = "side"

		animationPlayer.play("side_walk")

		$Sprite2D.flip_h = true if input.x < 0 else false

		animationPlayer.speed_scale = (
			velocity / maxSpeed
		).distance_to(Vector2.ZERO) + 0.5

	elif Input.get_action_strength("w"):

		facing = "up"

		animationPlayer.play("up_walk")

		animationPlayer.speed_scale = (
			velocity / maxSpeed
		).distance_to(Vector2.ZERO) + 0.5

	elif Input.get_action_strength("s"):

		facing = "down"

		animationPlayer.play("down_walk")

		animationPlayer.speed_scale = (
			velocity / maxSpeed
		).distance_to(Vector2.ZERO) + 0.5

	# Idle animations
	elif not attacking:

		match facing:

			"side":
				animationPlayer.play("side_idle")

			"up":
				animationPlayer.play("up_idle")

			"down":
				animationPlayer.play("idle front")

		animationPlayer.speed_scale = 0.75

	var lerpWeight = delta * (
		acceleration if input else friction
	)

	velocity = lerp(
		velocity,
		input * maxSpeed,
		lerpWeight
	)

	move_and_slide()

func attack():

	attacking = true

	velocity = Vector2.ZERO

	match facing:

		"side":
			animationPlayer.play("side_attack")

		"up":
			animationPlayer.play("up_attack")

		"down":
			animationPlayer.play("down_attack")

	await animationPlayer.animation_finished

	attacking = false

func player():
	pass

func collect(item):
	inventory.insert(item)
