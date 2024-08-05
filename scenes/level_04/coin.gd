extends CharacterBody2D

# Called when the node enters the scene tree for the first time
func _ready():
	$AnimatedSprite2D.frame_changed.connect(_on_AnimatedSprite2D_frame_changed)
	$AnimatedSprite2D.play("default")
	

func _on_area_2d_area_entered(area):
	$AnimatedSprite2D.play("collected")
	


func _on_area_2d_body_entered(body):
	$AnimatedSprite2D.play("collected")
func _on_AnimatedSprite2D_frame_changed():
	var animated_sprite = $AnimatedSprite2D
	if animated_sprite.frame == 9:
		hide()
		$CollisionShape2D.disabled = true
		$Area2D/CollisionShape2D.disabled = true
		await get_tree().create_timer(.5).timeout
		$CollisionShape2D.disabled = false
		$Area2D/CollisionShape2D.disabled = false
		$AnimatedSprite2D.play("default")
		show()
