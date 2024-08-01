extends CharacterBody2D

@onready var flight_timer = $FlightTimer
@onready var hit_box = $HitBox
@export var speed = 200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0
static var id = 0
var has_exit = false
var state_scene : Object
var thrower : Object

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
		# Bounce
		if $RayCast2D.is_colliding():
			direction *= -1
			$RayCast2D.target_position = Vector2($RayCast2D.target_position.x * -1, 0)
			$Sprite2D.flip_h = ($Sprite2D.flip_h != true)
			
func use(player : Object):
	thrower = player
	direction = player.facing
	flight_timer.start()
	# Move scene from Player to Level scenes.
	player.get_node("Hand").remove_child(self)
	state_scene.add_child(self)
	state_scene.get_node("Bullet" + str(id)).global_position = player.get_node("Hand").global_position
	hit_box.set_deferred("monitoring", true)
	hit_box.set_deferred("monitorable", true)
	$AudioStreamPlayer2D.stream = load("res://assets/sounds/shot-gun_D_minor.wav")
	$AudioStreamPlayer2D.play()

func alt_use(player : Object):
	pass

func _on_flight_timer_timeout():
	queue_free()

func _on_hit_box_body_entered(body):
	if has_exit:
		queue_free()
	if not body.is_in_group("player"):  # Edge case: projectile immediately hits the environment.
		queue_free()
	if body.is_in_group("player") and body != thrower: # Edge case: thrower stands too close to another player.
		body.death()
		queue_free()

func _on_hit_box_area_entered(area):
	if has_exit:
		queue_free()
	if not area.is_in_group("player"): # Edge case: projectile immediately hits the environment.
		queue_free()

func _on_hit_box_body_exited(body):
	has_exit = true
