extends CharacterBody2D

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
var facing
var spawn_position

func _ready():
	pass
	
func _process(delta):
	pass

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
		
		# Flip hand position.
		if $AnimatedSprite2D.flip_h and $Hand.get_child_count():
			$Hand.position = Vector2(-6, 1)
			if $Hand.get_children()[0] is CharacterBody2D:
				$Hand.get_children()[0].get_node("RayCast2D").target_position = Vector2(-8.5, 0)
				$Hand.get_children()[0].get_node("Sprite2D").flip_h = true
		elif $Hand.get_child_count():
			$Hand.position = Vector2(6, 1)
			if $Hand.get_children()[0] is CharacterBody2D:
				$Hand.get_children()[0].get_node("RayCast2D").target_position = Vector2(8.5, 0)
				$Hand.get_children()[0].get_node("Sprite2D").flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
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

func _on_hazard_detector_area_entered(area):
	if area.is_in_group("hazard"):
		global_position = spawn_position

func _on_hazard_detector_body_entered(body):
		global_position = spawn_position
		print("yo dead")
