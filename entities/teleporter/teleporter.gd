extends Node2D

@onready var ray = $RayCast2D
var player : Object

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		if not ray.is_colliding():
			player.global_position = get_global_mouse_position()
			queue_free()
			player.get_node("Hand").remove_child(self)

func use(player : Object):
	self.player = player
	ray.target_position = get_local_mouse_position()

func alt_use(player : Object):
	pass
