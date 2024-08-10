extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@export var belt_force = -1
var players : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.speed_scale = belt_force
	sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for player in players:
		player.position.x += belt_force


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		players.append(body)


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		players.erase(body)
