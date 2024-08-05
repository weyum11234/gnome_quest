extends CharacterBody2D


func _ready():
	$AnimatedSprite2D.play("default")
	
func _on_area_2d_area_entered(area):
	$AnimatedSprite2D.play("destroy")
	await get_tree().create_timer(2).timeout
	$AnimatedSprite2D.play("regrow")


func _on_area_2d_body_entered(body):
	$AnimatedSprite2D.play("destroy")
	await get_tree().create_timer(2).timeout
	$AnimatedSprite2D.play("regrow")
