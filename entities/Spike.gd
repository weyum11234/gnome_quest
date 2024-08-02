extends CharacterBody2D

var direction = Vector2()
var speed = 200.0
var lifetime = 2.0
var hit = false

func _ready():
	$AnimatedSprite2D.play("default")
	$CollisionShape2D.disabled = false
	await get_tree().create_timer(lifetime).timeout
	die()

func _process(delta):
	if not hit:
		position += direction * speed * delta

func die():
	hit = true
	$CollisionShape2D.disabled = true
	speed = 0
	$AnimatedSprite2D.play("hit")
	queue_free()
	
	
func _on_area_2d_area_entered(area):
	die()
