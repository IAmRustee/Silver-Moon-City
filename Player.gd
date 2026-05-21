extends CharacterBody2D

var score: int = 0

@export var speed: int = 100
@export var jumpForce: int = 1000000
@export var gravity: int = 800

var grounded: bool = false

@onready var sprite = $Sprite

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0

func _physics_process(delta: float) -> void:
	#velocity
	velocity = Vector2.DOWN * 5
	move_and_slide()
	velocity.x = 0
	
	#movement inputs
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
