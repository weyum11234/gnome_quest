extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var hit_box = $HitBox
@export var speed = 2000.0

var state_scene : Object
static var id = 0
var grace_period_time = 0.1
var grace_period_timer = 0.0
var thrower : Object
var has_exit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	id += 1
	name = "GoldKnife" + str(id)

func _physics_process(delta):
	if thrower:
		var mouse_position = get_global_mouse_position()
		position = position.move_toward(mouse_position, speed * delta)
		sprite.rotate(PI / 10)



func use(player : Object):
	thrower = player
	# Move scene from Player to Level scenes.
	player.get_node("Hand").remove_child(self)
	state_scene.add_child(self)
	state_scene.get_node("GoldKnife" + str(id)).global_position = player.get_node("Hand").global_position
	player.get_node("Camera2D").zoom = Vector2(0.5, 0.5)
	player.set_physics_process(false)
	player.set_process_input(false)
	hit_box.set_deferred("monitoring", true)
	hit_box.set_deferred("monitorable", true)
	
func alt_use(player : Object):
	pass
	
func reset():
	thrower.get_node("Camera2D").zoom = Vector2(1.4, 1.4)
	thrower.set_physics_process(true)
	thrower.set_process_input(true)
	queue_free()

func _on_flight_timer_timeout():
	reset()


func _on_hit_box_body_entered(body):
	if has_exit:
		reset()
	if not body.is_in_group("player"):  # Edge case: projectile immediately hits the environment.
		reset()
	if body.is_in_group("player") and body != thrower: # Edge case: thrower stands too close to another player.
		body.death()
		reset()


func _on_hit_box_area_entered(area):
	if has_exit:
		reset()
	if not area.is_in_group("player"): # Edge case: projectile immediately hits the environment.
		reset()


func _on_hit_box_body_exited(body):
	has_exit = true
