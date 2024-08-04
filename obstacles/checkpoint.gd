extends Area2D

@onready var animation = $AnimationPlayer
@onready var audio = $AudioStreamPlayer2D
var players : Array



func _on_body_entered(body):
	if body not in players:
		body.spawn_position = self.global_position
		animation.play("raise")
		audio.stream = load("res://assets/sounds/mixkit-retro-game-notification-212.wav")
		audio.play()
		players.append(body)
