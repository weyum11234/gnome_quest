extends Node2D

@export var boost_time = 5.0
@onready var boost_timer = 0.0
@onready var new_grav = 0.3
var player : Object

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player and boost_timer < boost_time:
		player.gravity_multiplier = new_grav
		boost_timer += delta
	elif player:
		player.gravity_multiplier = 1.0
		queue_free()

func use(player : Object):
	if boost_timer == 0:
		self.player = player

func alt_use(player : Object):
	if boost_timer == 0:
		self.player = player
		new_grav = 0.0
		
func reset():
	get_parent().get_parent().gravity_multiplier = 1.0
	queue_free()
