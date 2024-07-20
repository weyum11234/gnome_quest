extends CharacterBody2D

# Define the movement distance and speed
@export var movement_distance: float = 10.0
@export var movement_speed: float = 10.0

# The original position of the node
var original_position: Vector2
var target_position: Vector2
@export var direction: bool = true # true for forward, false for backward
var moving_forward: bool = true

func _ready():
	$AnimatedSprite2D.play()
	original_position = position
	if direction:
		target_position = original_position + Vector2(0, movement_distance)
	else:
		target_position = original_position - Vector2(0, movement_distance)

func _process(delta):
	var movement_amount = movement_speed * delta
	if direction:
		if moving_forward:
			position.y += movement_amount
			if position.y >= target_position.y:
				position.y = target_position.y
				moving_forward = false
		else:
			position.y -= movement_amount
			if position.y <= original_position.y:
				position.y = original_position.y
				moving_forward = true
	else:
		if moving_forward:
			position.y -= movement_amount
			if position.y <= target_position.y:
				position.y = target_position.y
				moving_forward = false
		else:
			position.y += movement_amount
			if position.y >= original_position.y:
				position.y = original_position.y
				moving_forward = true
