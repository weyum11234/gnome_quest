extends Node2D

@export var boost_time = 5.0
@onready var boost_timer = 0.0
var player : Object
var walk_speed : int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player and boost_timer < boost_time:
		player.speed = walk_speed * 1.5
		boost_timer += delta
	elif player:
		player.speed = walk_speed
		queue_free()

func use(player : Object):
	if boost_timer == 0:
		self.player = player
		walk_speed = player.speed

func alt_use(player : Object):
	pass

func reset():
	get_parent().get_parent().speed = walk_speed
	queue_free()
