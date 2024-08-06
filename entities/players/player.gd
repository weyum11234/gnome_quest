extends CharacterBody2D
#mnms
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
var spawn_time = 1.0
var spawn_timer = -1
var facing = 1
var spawn_position : Vector2

func _ready():
	pass
	
func _process(delta):
	if spawn_timer > -1 and spawn_timer < spawn_time:
		spawn_timer += delta
	elif spawn_timer > spawn_time:
		set_physics_process(true)
		set_process_input(true)
		animation = "idle"
		spawn_timer = -1

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
	spawn_timer = 0
	global_position = spawn_position
	set_physics_process(false)
	set_process_input(false)
	animation = "respawn"
	$AnimatedSprite2D.play(animation)
	$AudioStreamPlayer2D.play()


func _on_wind_detector_area_entered(area):
	gravity_multiplier = -1.8
func _on_wind_detector_area_exited(area):
	#await get_tree().create_timer(0.005).timeout
	gravity_multiplier = 1

