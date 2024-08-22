extends Node2D

@onready var ray = $RayCast2D
var player : Object

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		if not ray.is_colliding():
			player.global_position = get_global_mouse_position()
			reset()

func use(player : Object):
	self.player = player
	ray.target_position = get_local_mouse_position()

func alt_use(player : Object):
	pass

func reset():
	queue_free()
