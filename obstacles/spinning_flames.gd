extends CharacterBody2D

# Define the rotation speed (in radians per second)
@export var rotation_speed: float = 1.0

func _ready():
	$AnimatedSprite2D.play()
	$AnimatedSprite2D2.play()
	$AnimatedSprite2D3.play()
	$AnimatedSprite2D4.play()
	$AnimatedSprite2D5.play()
	$AnimatedSprite2D6.play()
	$AnimatedSprite2D7.play()
	$AnimatedSprite2D8.play()
func _process(delta):
	# Rotate the CharacterBody2D node continuously
	rotation += rotation_speed * delta
