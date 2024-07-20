extends CharacterBody2D


@export var speed = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0
var state_scene : Object
static var id = 0
var grace_period_time = 0.1
var grace_period_timer = 0.0

func _ready():
	id += 1
	name = "Bullet" + str(id)
	$AnimationPlayer.play("bullet_spin")

func _physics_process(delta):
	if direction != 0:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
		# Handle movement.
		velocity.x = direction * speed
		move_and_slide()
		# Grace period timer to ensure bullet doesn't instant kill the user.
		if grace_period_timer < grace_period_time:
			grace_period_timer += delta
		else:
			$Area2D.add_to_group("hazard")
		# Handles collision.
		if $RayCast2D.is_colliding():
			# Delete bullet when it kills a player.
			if $RayCast2D.get_collider().name == "Player1":
				queue_free()
			# Otherwise, bounce.
			direction *= -1
			$RayCast2D.target_position = Vector2($RayCast2D.target_position.x * -1, 0)
			$Sprite2D.flip_h = ($Sprite2D.flip_h != true)
		
func use(player : Object):
	direction = player.facing
	# Move scene from Player to Level scenes.
	player.get_node("Hand").remove_child(self)
	state_scene.add_child(self)
	state_scene.get_node("Bullet" + str(id)).global_position = player.get_node("Hand").global_position
