extends Node2D

@export var boost_time = 3.0
@onready var boost_timer = 0.0
var player : Object
var jump_velo : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player and boost_timer < boost_time:
		player.jump_velocity = jump_velo * 3
		boost_timer += delta
	elif player:
		player.jump_velocity = jump_velo
		queue_free()
		player.get_node("Hand").remove_child(self)

func use(player : Object):
	if boost_timer == 0:
		self.player = player
		jump_velo = player.jump_velocity
		
func alt_use(player : Object):
	pass
