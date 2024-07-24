extends CharacterBody2D

@export var speed = 400.0

var direction = Vector2.ZERO
var mouse_position : Vector2
var state_scene : Object
static var id = 0
var grace_period_time = 0.1
var grace_period_timer = 0.0
var flight_time = 5.0
var flight_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	id += 1
	name = "Knife" + str(id)

func _physics_process(delta):
	if direction:
		velocity.x = speed * direction.x
		velocity.y = speed * direction.y
		
		# SPIN!!! AND WHOOSH!!!
		$Sprite2D.rotate(PI / 10)
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.play()
		
		if grace_period_timer < grace_period_time:
			grace_period_timer += delta
		else:
			$Area2D.add_to_group("hazard")
			# Delete knife.
			if $RayCast2D.is_colliding() or flight_timer > flight_time:
				queue_free()	
			# Update flight timer.
			flight_timer += delta
			
		move_and_slide()


func use(player : Object):
	var mouse_position = get_global_mouse_position()
	direction = (mouse_position - global_position).normalized()
	# Ensure RayCast and Sprite point in the positive x-axis.
	scale.x = abs(scale.x)
	look_at(mouse_position)
	# Move scene from Player to Level scenes.
	player.get_node("Hand").remove_child(self)
	state_scene.add_child(self)
	state_scene.get_node("Knife" + str(id)).global_position = player.get_node("Hand").global_position
	
func alt_use(player : Object):
	pass
