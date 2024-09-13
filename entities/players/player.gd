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
@export var push_speed = 100
var force = Vector2.ZERO
var pushed_velo = 0

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
	else:
		spawn_position = global_position
		add_to_group("players")

func _process(_delta):
	sprite.play(current_animation)	

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
		force = direction * 1
		if velocity.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		current_animation = "walk"
	else:
		velocity.x = move_toward(velocity.x, 0, speed) + pushed_velo
		force = 0
		
	# Flip hand.
	if sprite.flip_h and hand.get_child_count():
		hand.position.x = -6
		hand.get_child(0).scale.x = -1
	elif hand.get_child_count():
		hand.position.x = 6
		hand.get_child(0).scale.x = 1
	
	# Item.
	if player_input.do_use and hand.get_child_count() > 0 and is_multiplayer_authority():
		print("haw yee")
		hand.get_child(0).scale.x = 1
		hand.get_child(0).use(self)
	
	player_collision()
	move_and_slide()

func player_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		var other_player = collision.get_collider()
		if collision.get_collider() is CharacterBody2D and collision.get_collider().is_in_group("players") and force != 0 and normal.y == 0:
			
			# Calculate push direction and force
			var push_direction = force
			var push_force = push_direction * push_speed
			
			# Slightly reduce this player's velocity
			pushed_velo = push_force
			
			# Apply push force to the other player
			other_player.pushed_velo = push_force
		else:
			pushed_velo = 0

func _on_hurt_box_area_entered(_area):
	if is_multiplayer_authority():
		death()

func _on_hurt_box_body_entered(_body):
	if is_multiplayer_authority():
		death()

func death():
	set_physics_process(false)
	set_process(false)
	
	if hand.get_child_count() > 0:
		for item in hand.get_children():
			item.reset()
	
	current_animation = "death"
	sprite.play(current_animation)
	audio.play()


func _on_animated_sprite_2d_animation_finished():
	match current_animation:
		"death":
			global_position = spawn_position
			current_animation = "respawn"
			sprite.play(current_animation)
		"respawn":
			set_physics_process(true)
			set_process(true)
