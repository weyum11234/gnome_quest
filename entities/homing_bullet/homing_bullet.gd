extends CharacterBody2D

@export var speed = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
static var id = 0
var has_exit = false
var players : Node
var target : Object
var player : Object

func _ready():
	if not is_multiplayer_authority():
		set_physics_process(false)

func _physics_process(delta):
	if target:
		look_at(target.global_position)
		position = position.move_toward(target.global_position, speed * delta)
		target = find_target()
		
func set_values(id : int, player : Object, parent : Node):
	self.id = id
	self.player = player
	self.players = parent.get_parent().get_node("Players")
	name = str(id)
	
	target = find_target()
	global_position = player.hand.global_position
	
	$HitBox.set_deferred("monitoring", true)
	$AnimationPlayer.play("bullet_spin")

func find_target() -> Object:
	var shortest_distance = INF
	var closest_player
	for c in players.get_children():
		if c == player:
			continue
		var current_distance = position.distance_to(c.position)
		if current_distance < shortest_distance:
			closest_player = c
			shortest_distance = current_distance
	return closest_player
			
func _on_flight_timer_timeout():
	queue_free()

func _on_hit_box_body_entered(body):
	if has_exit:
		queue_free()
	if not body.is_in_group("player"):  # Edge case: projectile immediately hits the environment.
		queue_free()
	if body.is_in_group("player") and body != player: # Edge case: thrower stands too close to another player.
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
