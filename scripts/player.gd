extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $Sprite2D/AnimationPlayer

@export var inventory: Inv

const maxSpeed: int = 200
const acceleration: int = 5
const friction: int = 8

func _physics_process(delta: float) -> void:
	var input = Vector2(
		Input.get_action_strength("d") - Input.get_action_strength("a"),
		Input.get_action_strength("s") - Input.get_action_strength("w")
	).normalized()
	
	if Input.get_action_strength("d") or Input.get_action_strength("a"):
		animationPlayer.play("side_walk")
		$Sprite2D.flip_h = true if input.x < 0 else false
		animationPlayer.speed_scale = (velocity/maxSpeed).distance_to(Vector2.ZERO) + 0.5
	elif Input.get_action_strength("w"):
		animationPlayer.play("up_walk")
		animationPlayer.speed_scale = (velocity/maxSpeed).distance_to(Vector2.ZERO) + 0.5
	elif Input.get_action_strength("s"): 
		animationPlayer.play("down_walk")
		animationPlayer.speed_scale = (velocity/maxSpeed).distance_to(Vector2.ZERO) + 0.5
	else: 
		animationPlayer.play("idle front")
		animationPlayer.speed_scale = 0.75
	
	var lerpWeight = delta * (acceleration if input else friction)
	velocity = lerp(velocity, input * maxSpeed, lerpWeight)
	
	move_and_slide()
	
func player():
	pass

func collect(item):
	inventory.insert(item)
