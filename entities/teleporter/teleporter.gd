extends Node2D

var player : Object

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		player.global_position = get_global_mouse_position()
		reset()

func use(player : Object):
	self.player = player

func alt_use(player : Object):
	pass

func reset():
	queue_free()
