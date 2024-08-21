extends CharacterBody2D

# Nodes
@onready var sprite = $AnimatedSprite2D
@onready var hand = $Hand
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer2D
@onready var player_input = $PlayerInput

# Physics
@export var speed = 200.0
@export var jump_velocity = -170.0
@export var gravity_multiplier = 1.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Timers
@export var long_jump_time = 0.25
var long_jump_timer = 0.0

# State
@export var player_id = 1:
	set(id):
		player_id = id
		$PlayerInput.set_multiplayer_authority(id)
@onready var current_animation = "idle"
var spawn_position : Vector2

func _ready():
	if not is_multiplayer_authority():
		set_process(false)

func _physics_process(delta):
	current_animation = "idle"
	
	# Gravity.
	if not is_on_floor() and not player_input.jumping:
		velocity.y += gravity * gravity_multiplier * delta

	# Jump.
	if player_input.do_jump and is_on_floor():
		velocity.y = jump_velocity
		player_input.jumping = true
	elif player_input.do_long_jump and player_input.jumping:
		velocity.y = jump_velocity
	
	if player_input.jumping and player_input.do_long_jump and long_jump_timer < long_jump_time:
		long_jump_timer += delta
		current_animation = "jump"
	else:
		player_input.jumping = false
		long_jump_timer = 0.0

	# Walk.
	var direction = player_input.direction
	if direction:
		velocity.x = speed * direction
		if velocity.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		current_animation = "walk"
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Item.
	if player_input.do_use:
		hand.get_child(0).use(self)
	
	move_and_slide()
	sprite.play(current_animation)

	
