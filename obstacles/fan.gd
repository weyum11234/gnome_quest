extends CharacterBody2D

# Called when the node enters the scene tree for the first time
func _ready():
	$AnimatedSprite2D.play("default")


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.gravity_multiplier = -1.8

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		body.gravity_multiplier = 1.0
