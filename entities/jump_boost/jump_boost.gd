extends Node2D

@export var boost_time = 3.0
@onready var boost_timer = 0.0
var player : Object
var jump_velo : int

func _ready():
	var rng = RandomNumberGenerator.new()
	name = str(rng.randi())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player and boost_timer < boost_time:
		player.jump_velocity = jump_velo * 1.5
		boost_timer += delta
	elif player:
		reset()

func use(player : Object):
	if boost_timer == 0:
		self.player = player
		jump_velo = player.jump_velocity

func reset():
	get_parent().get_parent().jump_velocity = jump_velo
	queue_free()
