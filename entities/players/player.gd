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
	if not multiplayer.is_server():
		set_process(false)

func _physics_process(delta):
	if multiplayer.is_server():
		apply_input(delta)
	else:
		animate(current_animation, delta)

func apply_input(delta : float):
	if not is_on_floor() and not player_input.jumping:
		velocity.y += gravity * gravity_multiplier * delta

	if player_input.do_jump and is_on_floor():
		velocity.y = jump_velocity
		player_input.jumping = true
	elif player_input.do_long_jump and player_input.jumping:
		velocity.y = jump_velocity
	
	if player_input.jumping and player_input.do_long_jump and long_jump_timer < long_jump_time:
		long_jump_timer += delta
	else:
		player_input.jumping = false
		long_jump_timer = 0.0

	move_and_slide()

func animate(anim : String, delta : float):
	pass
