extends CharacterBody2D


@export var speed = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target : Object
var state_scene : Object
static var id = 0
var grace_period_time = 0.1
var grace_period_timer = 0.0

func _ready():
	id += 1
	name = "Bullet" + str(id)
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
		#if $RayCast2D.is_colliding():
			#queue_free()
		
func use(player : Object):
	# TODO: Set target to closest player
	target = player
	
	# Ensure RayCast and Sprite point in the positive x-axis.
	scale.x = abs(scale.x)
	
	# Move scene from Player to Level scenes.
	player.get_node("Hand").remove_child(self)
	state_scene.add_child(self)
	state_scene.get_node("Bullet" + str(id)).global_position = player.get_node("Hand").global_position

func alt_use(player : Object):
	pass
