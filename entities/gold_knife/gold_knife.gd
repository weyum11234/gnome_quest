extends Node2D

@export var speed = 500.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	position = position.move_toward(mouse_position, speed * delta)
	
	if position == mouse_position:
		$CPUParticles2D.emitting = false
	else:
		$CPUParticles2D.emitting = true
