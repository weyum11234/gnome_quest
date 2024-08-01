extends StaticBody2D

@onready var collider = $CollisionShape2D
@onready var animation = $AnimationPlayer
@onready var on_timer = $OnTimer
@onready var off_timer = $OffTimer
@export var on_time = 10.0
@export var off_time = 5.0

func _ready():
	on_timer.wait_time = on_time
	off_timer.wait_time = off_time
	on_timer.start()
	animation.play("RESET")


func _on_on_timer_timeout():
	animation.play("shake")


func _on_off_timer_timeout():
	collider.disabled = false
	on_timer.start()
	animation.play("RESET")


func _on_animation_player_animation_finished(anim_name):
	# Could probably combine the shake and collapse animations into one
	if anim_name == "shake":
		animation.play("collapse")
	if anim_name == "collapse":
		collider.disabled = true
		off_timer.start()
