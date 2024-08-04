extends Node2D

var direction = 1
var speed = 200.0
var lifetime = 2.0
var hit = false

func _ready():
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D2.play("default")
	await get_tree().create_timer(lifetime).timeout
	die()

func _physics_process(delta):
	if not hit:
		position.x += speed * delta * direction

func die():
	hit = true
	speed = 0
	$AnimatedSprite2D2.play("hit")
	queue_free()  # Remove the cannonball after it "dies"
