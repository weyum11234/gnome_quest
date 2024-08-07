extends StaticBody2D


@onready var cannon_ball = load("res://obstacles/cannon_ball.tscn")
@onready var sprite = $AnimatedSprite2D
@onready var firepoint = $Marker2D
@onready var cooldown_timer = $CooldownTimer

func _ready():
	cooldown_timer.start()

func fire():
	var spawned_ball = cannon_ball.instantiate()
	spawned_ball.direction = firepoint.scale.x
	spawned_ball.global_position = firepoint.global_position
	get_parent().add_child(spawned_ball)

func _on_animated_sprite_2d_animation_finished():
	fire()
	cooldown_timer.start()
	sprite.play("default")
	

func _on_cooldown_timer_timeout():
	sprite.play("shoot")
