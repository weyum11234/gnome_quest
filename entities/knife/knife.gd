extends CharacterBody2D

@onready var flight_timer = $FlightTimer
@onready var hit_box = $HitBox
@export var speed = 400.0

var id : int
var direction = Vector2.ZERO
var has_exit = false
var state_scene : Object
var thrower : Object

# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_multiplayer_authority():
		set_process(false)
		set_physics_process(false)
		
	var rng = RandomNumberGenerator.new()
	id = rng.randi()
	name = str(id)

func _physics_process(delta):
	if direction:
		velocity.x = speed * direction.x
		velocity.y = speed * direction.y
		move_and_slide()

func use(player : Object):
	# Initialization.
	thrower = player
	var mouse_position = get_global_mouse_position()
	direction = (mouse_position - global_position).normalized()
	look_at(mouse_position)
	flight_timer.start()
	# Move scene from Player to Level scenes.
	print(state_scene)
	player.get_node("Hand").remove_child(self)
	state_scene.get_node("Items").add_child(self)
	state_scene.get_node("Items").get_node(str(id)).global_position = player.get_node("Hand").global_position
	hit_box.set_deferred("monitoring", true)
	hit_box.set_deferred("monitorable", true)

func alt_use(player : Object):
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
