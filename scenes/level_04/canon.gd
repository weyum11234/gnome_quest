extends StaticBody2D

var canon_ball = load("res://obstacles/canon_ball.tscn")

@export var shooting : bool
var firerate = 2

@onready var firepoint = $Marker2D

func _ready():
	shooting = true
	shoot()

func shoot():
	$AnimatedSprite2D.play("shoot")
	while shooting:
		fire()
		await get_tree().create_timer(firerate).timeout

func fire():
	var spawned_ball = canon_ball.instantiate()
	spawned_ball.direction = firepoint.scale.x
	spawned_ball.global_position = firepoint.global_position
	get_parent().add_child(spawned_ball)
