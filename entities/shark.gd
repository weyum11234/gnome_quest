extends CharacterBody2D

@export var oval_width: float = 200.0
@export var oval_height: float = 100.0
@export var jump_duration: float = 2.0
@export var delay: bool = false

var start_position: Vector2
var jump_time: float = 0.0
var jumping: bool = false

func _ready():
	$AnimatedSprite2D.play()
	start_position = position

func _process(delta):
	if delay and not jumping:
		await get_tree().create_timer(1).timeout
		jumping = true
		jump_time = 0.0

	if jumping:
		jump_time += delta
		if jump_time > jump_duration:
			jumping = false
			position = start_position
		else:
			# Calculate the position in the oval (ellipse) path
			var t = jump_time / jump_duration * TAU # TAU = 2 * PI
			position.x = start_position.x + oval_width / 2 * cos(t)
			position.y = start_position.y - oval_height / 2 * sin(t)
	else:
		# Regular continuous movement (optional)
		pass

	# Flip the sprite based on the direction of 
