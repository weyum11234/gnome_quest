extends CharacterBody2D


@export var speed = 300.0
@onready var anim_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer2D
@onready var hit_box = $HitBox

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
static var id = 0
var has_exit = false
var state_scene : Object
var target : Object
var thrower : Object


func _ready():
	id += 1
	name = "HomingBullet" + str(id)
	$AnimationPlayer.play("bullet_spin")

func _physics_process(delta):
	if target:
		look_at(target.global_position)
		position = position.move_toward(target.global_position, speed * delta)
		
func use(player : Object):
	thrower = player
	# TODO: Set target to closest player.
	target = state_scene.get_node("Dummy")
	# Ensure sprite point in the positive x-axis.
	scale.x = abs(scale.x)
	# Move scene from Player to Level scenes.
	player.get_node("Hand").remove_child(self)
	state_scene.add_child(self)
	state_scene.get_node("HomingBullet" + str(id)).global_position = player.get_node("Hand").global_position
	hit_box.set_deferred("monitoring", true)
	hit_box.set_deferred("monitorable", true)
	$AudioStreamPlayer2D.stream = load("res://assets/sounds/shot-gun_D_minor.wav")
	$AudioStreamPlayer2D.play()

func alt_use(player : Object):
	pass

func _on_timer_timeout():
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
