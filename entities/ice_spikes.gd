extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var collider = $CollisionShape2D
@onready var respawn_timer = $RespawnTimer
var animation = "default"

#func _ready():
	#$AnimatedSprite2D.play("default")
	#
#func _on_area_2d_area_entered(area):
	#$AnimatedSprite2D.play("destroy")
	#await get_tree().create_timer(2).timeout
	#$AnimatedSprite2D.play("regrow")
#
#
#func _on_area_2d_body_entered(body):
	#$AnimatedSprite2D.play("destroy")
	#await get_tree().create_timer(2).timeout
	#$AnimatedSprite2D.play("regrow")
	



func _on_body_entered(body):
	if body.is_in_group("player"):
		# Destroy
		set_collision_layer_value(3, false)
		set_collision_mask_value(2, false)
		animation = "destroy"
		sprite.play(animation)


func _on_animated_sprite_2d_animation_finished():
	match animation:
		"destroy":
			respawn_timer.start()
		"regrow":
			set_collision_layer_value(3, true)
			set_collision_mask_value(2, true)
			animation = "default"
			sprite.play(animation)


func _on_respawn_timer_timeout():
	animation = "regrow"
	sprite.play(animation)
