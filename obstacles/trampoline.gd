extends AnimatableBody2D

@export var tramp_jump = 0
@export var tramp_jump_x = 0

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.velocity.y = tramp_jump
		body.velocity.x = tramp_jump_x
		
