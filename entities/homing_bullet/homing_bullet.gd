extends CharacterBody2D


@export var speed = 300.0
@onready var anim_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target : Object
var state_scene : Object
static var id = 0
var grace_period_time = 0.1
var grace_period_timer = 0.0
var flight_time = 5.0
var flight_timer = 0.0

func _ready():
	id += 1
	name = "HomingBullet" + str(id)
	$AnimationPlayer.play("bullet_spin")

func _physics_process(delta):
	if target:
		look_at(target.global_position)
		position = position.move_toward(target.global_position, speed * delta)

		# Grace period timer to ensure bullet doesn't instant kill the user.
		if grace_period_timer < grace_period_time:
			grace_period_timer += delta
		else:
			$Area2D.add_to_group("hazard")
			# Delete bullet.
			if $RayCast2D.is_colliding() or flight_timer > flight_time:
				queue_free()	
			# Update flight timer.
			flight_timer += delta
		
		
func use(player : Object):
	# TODO: Set target to closest player
	target = state_scene.get_node("Dummy")
	
	# Ensure RayCast and Sprite point in the positive x-axis.
	scale.x = abs(scale.x)
	
	# Move scene from Player to Level scenes.
	player.get_node("Hand").remove_child(self)
	state_scene.add_child(self)
	state_scene.get_node("HomingBullet" + str(id)).global_position = player.get_node("Hand").global_position
	$AudioStreamPlayer2D.stream = load("res://assets/sounds/shot-gun_D_minor.wav")
	$AudioStreamPlayer2D.play()

func alt_use(player : Object):
	pass
