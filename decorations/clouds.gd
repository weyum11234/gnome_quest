# Used for cloud_a, cloud_b, and cloud_c
extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var start = $Start
@onready var end = $End
@onready var target = $End
@export var speed = 100

func _process(delta):
	# Switch targets when reaching end points.
	if sprite.position == start.position:
		target = end
	elif sprite.position == end.position:
		target = start
	# Move.
	sprite.position = sprite.position.move_toward(target.position, speed * delta)
