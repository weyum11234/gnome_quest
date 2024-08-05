extends CharacterBody2D

@export var orbit_radius: float = 100.0
@export var orbit_speed: float = 1.0 # Radians per second
@export var delay: bool = false

var orbit_center: Vector2
var current_angle: float = 0.0

func _ready():
	$AnimatedSprite2D.play()
	# Set the initial position as the orbit center
	orbit_center = position
	# Initialize the position based on the initial angle
	update_position()

func _process(delta):
	if delay:
		# Update the angle based on the orbit speed and delta time
		current_angle += orbit_speed * delta

		# Ensure the angle is within the half-orbit range
		if orbit_speed > 0 and current_angle >= 0.0:
			current_angle = 0.0
			update_position()
			await get_tree().create_timer(1).timeout 
			current_angle = -PI
		elif orbit_speed < 0 and current_angle <= -PI:
			current_angle = -PI
			update_position()
			await get_tree().create_timer(1).timeout 
			current_angle = 0.0

	else:
		# Regular continuous rotation
		current_angle += orbit_speed * delta
		current_angle = wrapf(current_angle, 0.0, TAU)

	# Update the position based on the new angle
	update_position()

func update_position():
	position.x = orbit_center.x + orbit_radius * cos(current_angle)
	position.y = orbit_center.y + orbit_radius * sin(current_angle)
		
	# Flip the sprite based on the direction of movement
	# if orbit_speed > 0:
	# 	$AnimatedSprite2D.flip_h = (current_angle > PI / 2 and current_angle < 3 * PI / 2)
	# else:
	# 	$AnimatedSprite2D.flip_h = not (current_angle > PI / 2 and current_angle < 3 * PI / 2)
