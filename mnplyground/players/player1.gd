extends CharacterBody2D

# Declare the variables
@export var speed : float = 80.0
@export var jump_force : float = 300
@export var gravity : float = 1000.0

# Animation
var animated_sprite : AnimatedSprite2D

# Damage animation
var is_damaged : bool = false
var damage_animation_time : float = 1.0
var damage_timer : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite = $AnimatedSprite2D  # Replace with your AnimatedSprite2D node path
	animated_sprite.play("idle") 

func _on_Obstacle_body_entered(body):
	if body.is_in_group("Obstacle"):
		print("Entered obstacle")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Get the input direction
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	# Apply horizontal movement if not damaged
	if not is_damaged:
		velocity.x = direction.x * speed
	
	# Apply gravity
	velocity.y += gravity * delta
	
	# Flip the sprite based on direction
	if direction.x != 0 and not is_damaged:
		animated_sprite.flip_h = direction.x < 0  # Flip sprite horizontally if moving left

	# Play animations
	if direction.x != 0 and is_on_floor() and not is_damaged:
		animated_sprite.play("run")
	elif velocity.x == 0 and is_on_floor() and not is_damaged:
		animated_sprite.play("idle")

	# Jumping
	if is_on_floor() and Input.is_action_just_pressed("ui_up") and not is_damaged:
		velocity.y = -jump_force

	# Handle damage animation and obstacle collision
	if is_damaged:
		damage_timer += delta
		if damage_timer >= damage_animation_time:
			is_damaged = false
			damage_timer = 0.0
			# Reset animation state if needed
	# Move the character
	move_and_slide()
	
	
func _on_hazard_detector_body_entered(body):
	queue_free()
