extends StaticBody2D


@onready var cannon_ball = load("res://obstacles/cannon_ball.tscn")
@onready var sprite = $AnimatedSprite2D
@onready var firepoint = $Marker2D
@onready var cooldown_timer = $CooldownTimer
@export var cooldown_time = 4.0
@export var bullet_time = 1.0

func _ready():
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.start()

func fire():
	var spawned_ball = cannon_ball.instantiate()
	spawned_ball.get_node("FlightTimer").wait_time = bullet_time
	spawned_ball.direction = firepoint.scale.x
	spawned_ball.global_position = firepoint.global_position
	get_parent().add_child(spawned_ball)

func _on_animated_sprite_2d_animation_finished():
	fire()
	cooldown_timer.start()
	sprite.play("default")
	

func _on_cooldown_timer_timeout():
	sprite.play("shoot")
