extends Node2D

@onready var player_scene = preload("res://entities/players/player_1.tscn")
@onready var item_box_scene = preload("res://entities/item_box/item_box.tscn")
@onready var speed_boost_scene = preload("res://entities/speed_boost/speed_boost.tscn")
@onready var jump_boost_scene = preload("res://entities/jump_boost/jump_boost.tscn")
@onready var rng = RandomNumberGenerator.new()

var player : Object
var boxes : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_entities()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_entities():
	# Spawn player
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = Vector2(100, 200)
	
	# Spawn item boxes
	for i in range(3):
		boxes.append(item_box_scene.instantiate())
		boxes[i].connect("give_item", on_give_item)
		add_child(boxes[i])
		boxes[i].global_position = Vector2(100 + 30 * (i + 1), 200)

# Give player a random item.
func on_give_item():
	# Only gives item if hands are empty
	if not player.get_node("Hand").get_child_count():
		var i = rng.randi_range(0, 1)
		match i:
			0:
				player.get_node("Hand").add_child(speed_boost_scene.instantiate())
			1:
				player.get_node("Hand").add_child(jump_boost_scene.instantiate())
		print_debug("gave item")
	
