extends Node2D

@export var speed = 1.0
@export var move_end_point = Vector2.ZERO
@export var align_with_path = false

@onready var path = $Path2D
@onready var path_follow = $Path2D/PathFollow2D
@onready var body = $Path2D/AnimatableBody2D
@onready var animation = $AnimationPlayer
@onready var sprite = $Path2D/AnimatableBody2D/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if align_with_path:
		path_follow.rotates = true
		
	path.curve = Curve2D.new()
	path.curve.add_point(Vector2.ZERO)
	path.curve.add_point(move_end_point)
	animation.play("move")
	animation.speed_scale = speed

func _process(delta):
	sprite.rotate(PI / 15)
