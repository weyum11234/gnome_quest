extends CharacterBody2D

@export var movement_speed = 250.0
@export var direction = -1 # -1 for up, 1 for down
@export var flip_time = 2.0
var flip_timer = 0.0

func _ready():
	$AnimatedSprite2D.play()

func _process(delta):
	velocity.y = direction * movement_speed
	if flip_timer > flip_time:
		direction *= -1
		flip_timer = 0.0
	
	flip_timer += delta	
	move_and_slide()
	#var movement_amount = movement_speed * delta
	#if direction:
		#if moving_forward:
			#position.y += movement_amount
			#if position.y >= target_position.y:
				#position.y = target_position.y
				#moving_forward = false
		#else:
			#position.y -= movement_amount
			#if position.y <= original_position.y:
				#position.y = original_position.y
				#moving_forward = true
	#else:
		#if moving_forward:
			#position.y -= movement_amount
			#if position.y <= target_position.y:
				#position.y = target_position.y
				#moving_forward = false
		#else:
			#position.y += movement_amount
			#if position.y >= original_position.y:
				#position.y = original_position.y
				#moving_forward = true
	pass
