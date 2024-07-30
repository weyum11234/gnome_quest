extends Area2D

@onready var collider = $CollisionShape2D
@onready var emitter = $CPUParticles2D
@onready var flame_on_timer = $FlameOnTimer
@onready var flame_off_timer = $FlameOffTimer


func _process(delta):
	if emitter.emitting:
		collider.shape.points[0] = collider.shape.points[0].move_toward(Vector2(-6, -110), 35 * delta)
		collider.shape.points[1] = collider.shape.points[1].move_toward(Vector2(6, -110), 35 * delta)

func _on_flame_on_timer_timeout():
	# now turning off the flame
	collider.disabled = true
	collider.shape.points[0] = Vector2.ZERO
	collider.shape.points[1] = Vector2.ZERO
	emitter.emitting = false
	flame_off_timer.start()


func _on_flame_off_timer_timeout():
	# now turning on the flame
	collider.disabled = false
	emitter.emitting = true
	flame_on_timer.start()
	
