extends CharacterBody2D

# Nodes
@onready var sprite = $AnimatedSprite2D
@onready var hand = $Hand
@onready var cam = $Camera2D
@export var player_input : NetfoxPlayerInput

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
		player_input.set_multiplayer_authority(id)
@onready var current_animation = "idle"
@onready var dead = false
var spawn_position : Vector2


func _ready():
	spawn_position = global_position
	$RollbackSynchronizer.process_settings()

func _process(delta):
	sprite.play(current_animation)

func _rollback_tick(delta, tick, is_fresh):
	if dead:
		return
	
	_force_update_is_on_floor()
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
		
	# Flip hand.
	if sprite.flip_h and hand.get_child_count():
		hand.position.x = -6
		hand.get_child(0).scale.x = -1
	elif hand.get_child_count():
		hand.position.x = 6
		hand.get_child(0).scale.x = 1
	
	# Item.
	if player_input.do_use and hand.get_child_count() > 0 and is_multiplayer_authority():
		hand.get_child(0).scale.x = 1
		hand.get_child(0).use(self)
	
	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor

func _force_update_is_on_floor():
	var old_velocity = velocity
	velocity = Vector2.ZERO
	move_and_slide()
	velocity = old_velocity

func _on_hurt_box_area_entered(area):
	death()

func _on_hurt_box_body_entered(body):
	death()

func death():
	#dead = true
	
	if hand.get_child_count() > 0:
		for item in hand.get_children():
			#item.reset()
			pass
	
	current_animation = "death"
	sprite.play(current_animation)

func _on_animated_sprite_2d_animation_finished():
	match current_animation:
		"death":
			global_position = spawn_position
			current_animation = "respawn"
			sprite.play(current_animation)
		"respawn":
			#dead = false
			pass
