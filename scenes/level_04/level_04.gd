extends Node2D

@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.spawn_position = player.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
