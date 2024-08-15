extends Node2D

@onready var body = $StaticBody2D
@onready var sprite = $StaticBody2D/AnimatedSprite2D
@onready var start = $Start
@onready var end = $End
@onready var target = $End
@export var speed = 100

func _ready():
	sprite.play()

func _process(delta):
	# Switch targets when reaching end points.
	if body.position == start.position:
		target = end
		body.scale.x *= -1
	elif body.position == end.position:
		target = start
		body.scale.x *= -1
	# Move.
	body.position = body.position.move_toward(target.position, speed * delta)


func _on_tree_entered():
	print("manas")
