extends AnimatableBody2D

@export var tramp_jump_x = 0
@export var tramp_jump_y = -1000

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.velocity.x = tramp_jump_x
		body.velocity.y = tramp_jump_y
		
