extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $Sprite2D/AnimationPlayer

@export var inventory: Inv

const maxSpeed: int = 200
const acceleration: int = 5
const friction: int = 8

func _physics_process(delta: float) -> void:
	var input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	if Input.get_action_strength("ui_right") or Input.get_action_strength("ui_left"):
		animationPlayer.play("side_walk")
		$Sprite2D.flip_h = true if input.x < 0 else false
		animationPlayer.speed_scale = (velocity/maxSpeed).distance_to(Vector2.ZERO) + 0.5
	elif Input.get_action_strength("ui_up"):
		animationPlayer.play("up_walk")
		animationPlayer.speed_scale = (velocity/maxSpeed).distance_to(Vector2.ZERO) + 0.5
	elif Input.get_action_strength("ui_down"): 
		animationPlayer.play("down_walk")
		animationPlayer.speed_scale = (velocity/maxSpeed).distance_to(Vector2.ZERO) + 0.5
	else: 
		animationPlayer.play("idle front")
		animationPlayer.speed_scale = 0.75
	
	var lerpWeight = delta * (acceleration if input else friction)
	velocity = lerp(velocity, input * maxSpeed, lerpWeight)
	
	move_and_slide()

func collect(item):
	inventory.insert(item)
