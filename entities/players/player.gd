extends CharacterBody2D

# Nodes
@onready var sprite = $AnimatedSprite2D
@onready var hand = $Hand
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer2D

# Physics constants
@export var speed = 200.0
@export var jump_velocity = -170.0
@export var jump_time = 0.25
@export var coyote_time = 0.05
@export var gravity_multiplier = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping = false
var jump_timer = 0.0
var coyote_timer = 0.0

# State variables
@onready var animation = "idle"
var facing = 1
var spawn_position : Vector2

@export var player_id = 1:
	set(id):
		player_id = id
		set_multiplayer_authority(id)

func _ready():
	cam.enabled = is_multiplayer_authority()
	

func _physics_process(delta):
	# Set default animation every delta
	animation = "idle"
	
	# Add the gravity.
	if not is_on_floor() and not is_jumping:
		velocity.y += gravity * gravity_multiplier * delta
		coyote_timer += delta
	else:
		coyote_timer = 0

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		facing = direction
		animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	# Flip hand position.
	if $AnimatedSprite2D.flip_h and $Hand.get_child_count():
		$Hand.position = Vector2(-6, 1)
		if $Hand.get_children()[0] is CharacterBody2D:
			$Hand.get_children()[0].scale.x = abs($Hand.get_children()[0].scale.x) * -1
	elif $Hand.get_child_count():
		$Hand.position = Vector2(6, 1)
		if $Hand.get_children()[0] is CharacterBody2D:
			$Hand.get_children()[0].scale.x = abs($Hand.get_children()[0].scale.x)
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer < coyote_time):
		velocity.y = jump_velocity
		is_jumping = true
	elif Input.is_action_pressed("jump") and is_jumping:
		velocity.y = jump_velocity
		
	if is_jumping and Input.is_action_pressed("jump") and jump_timer < jump_time:
		jump_timer += delta
		animation = "jump"
	else:
		is_jumping = false
		jump_timer = 0

	$AnimatedSprite2D.play(animation)
	move_and_slide()

# Handle item interactions.
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and $Hand.get_child_count(): # Main use
			$Hand.get_children()[0].use(self)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and $Hand.get_child_count(): # Alternative use
			$Hand.get_children()[0].alt_use(self)

func _on_hurt_box_body_entered(body):
	death()

func _on_hurt_box_area_entered(area):
	death()

func death():
	set_physics_process(false)
	set_process_input(false)
	# Clear items upon death
	if hand.get_child_count():
		hand.get_children()[0].reset()
		pass
	animation = "death"
	sprite.play(animation)
	audio.play()
	

func _on_animated_sprite_2d_animation_finished():
	match animation:
		"death":
			global_position = spawn_position
			animation = "respawn"
			sprite.play(animation)
		"respawn":
			set_physics_process(true)
			set_process_input(true)
