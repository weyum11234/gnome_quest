extends CharacterBody2D

@export var speed = 2000.0

var state_scene : Object
static var id = 0
var grace_period_time = 0.1
var grace_period_timer = 0.0
var flight_time = 8.0
var flight_timer = 0.0
var player : Object

# Called when the node enters the scene tree for the first time.
func _ready():
	id += 1
	name = "GoldKnife" + str(id)

func _physics_process(delta):
	if player:
		var mouse_position = get_global_mouse_position()
		position = position.move_toward(mouse_position, speed * delta)
		
		$Sprite2D.rotate(PI / 10)
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.play()
		
		if grace_period_timer < grace_period_time:
			grace_period_timer += delta
		else:
			$Area2D.add_to_group("hazard")
			# Delete knife.
			if flight_timer > flight_time:
				player.get_node("Camera2D").zoom = Vector2(1.4, 1.4)
				player.set_physics_process(true)
				player.set_process_input(true)
				queue_free()	
			# Update flight timer.
			flight_timer += delta


func use(player : Object):
	self.player = player
	# Ensure RayCast and Sprite point in the positive x-axis.
	scale.x = abs(scale.x)
	# Move scene from Player to Level scenes.
	player.get_node("Hand").remove_child(self)
	state_scene.add_child(self)
	state_scene.get_node("GoldKnife" + str(id)).global_position = player.get_node("Hand").global_position
	player.get_node("Camera2D").zoom = Vector2(0.5, 0.5)
	player.set_physics_process(false)
	player.set_process_input(false)
	
func alt_use(player : Object):
	pass
