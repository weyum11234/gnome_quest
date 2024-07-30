extends Node2D

@export var speed = 0.5
@onready var animation = $AnimationPlayer
@onready var path = $Path2D
@onready var path_follow = $Path2D/PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("move")
	animation.speed_scale = speed
