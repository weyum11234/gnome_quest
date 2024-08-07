extends StaticBody2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("default")
