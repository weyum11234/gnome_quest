extends CharacterBody2D

@export var speed = 400.0

var id : int
var player : Object

var direction = Vector2.ZERO
var has_exit = false

func _ready():
	if not is_multiplayer_authority():
		set_physics_process(false)

func _physics_process(delta):
	if direction:
		velocity.x = speed * direction.x
		velocity.y = speed * direction.y
		move_and_slide()

func set_values(id : int, player : Object):
	#self.id = id
	#self.player = player
	#name = str(id)
	#
	#direction = (player.player_input.mouse_pos - player.hand.global_position).normalized()
	#look_at(direction)
	#global_position = player.hand.global_position
	#
	#$HitBox.set_deferred("monitoring", true)
	pass
	
func reset():
	queue_free()

func _on_flight_timer_timeout():
	queue_free()

func _on_hit_box_body_entered(body):
	if has_exit:
		queue_free()
	if not body.is_in_group("player"): # Edge case: projectile immediately hits the environment.
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

