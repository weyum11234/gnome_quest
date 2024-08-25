extends CharacterBody2D

@export var speed = 200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var id : int
var player : Object

var direction = 0
var has_exit = false

func _ready():
	if not is_multiplayer_authority():
		set_physics_process(false)

func _physics_process(delta):
	if direction != 0:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
		# Handle movement.
		velocity.x = direction * speed
		move_and_slide()
		
		# Bounce
		if $RayCast2D.is_colliding():
			direction *= -1
			$RayCast2D.target_position = Vector2($RayCast2D.target_position.x * -1, 0)
			$Sprite2D.flip_h = ($Sprite2D.flip_h != true)
			
func set_values(id : int, player : Object):
	self.id = id
	self.player = player
	name = str(id)
	
	direction = player.player_input.facing
	print(direction)
	look_at(Vector2(direction, 0))
	global_position = player.hand.global_position
	
	$HitBox.set_deferred("monitoring", true)
	$AnimationPlayer.play("bullet_spin")

func reset():
	queue_free()

func _on_flight_timer_timeout():
	queue_free()

func _on_hit_box_body_entered(body):
	if has_exit:
		queue_free()
	if not body.is_in_group("player"):  # Edge case: projectile immediately hits the environment.
		queue_free()
	if body.is_in_group("player") and body != player: # Edge case: player stands too close to another player.
		body.death()
		queue_free()

func _on_hit_box_area_entered(area):
	if has_exit:
		queue_free()
	if not area.is_in_group("player"): # Edge case: projectile immediately hits the environment.
		queue_free()

func _on_hit_box_body_exited(body):
	has_exit = true
	$HitBox.set_deferred("monitorable", true)
