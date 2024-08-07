extends Node2D
	
@onready var bullet_sprite = $BulletSprite
@onready var trail_sprite = $TrailSprite
@export var speed = 200.0
var direction : int

func _physics_process(delta):
	position.x += speed * direction * delta

func _on_flight_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		speed = 0 # Stop the bullet
		trail_sprite.visible = false # Stop the trail animation
		bullet_sprite.rotate(3 * PI / 2) # Orient the hit animation
		bullet_sprite.play("hit")

func _on_bullet_sprite_animation_finished():
	queue_free()
