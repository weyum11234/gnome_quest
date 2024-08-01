extends Node2D

@onready var player_scene = preload("res://entities/players/player.tscn")
@onready var item_box_scene = preload("res://entities/item_box/item_box.tscn")
@onready var speed_boost_scene = preload("res://entities/speed_boost/speed_boost.tscn")
@onready var jump_boost_scene = preload("res://entities/jump_boost/jump_boost.tscn")
@onready var grav_cntrl_scene = preload("res://entities/gravity_controller/gravity_controller.tscn")
@onready var teleporter_scene = preload("res://entities/teleporter/teleporter.tscn")
@onready var bullet_scene = preload("res://entities/bullet/bullet.tscn")
@onready var homing_bullet_scene = preload("res://entities/homing_bullet/homing_bullet.tscn")
@onready var knife_scene = preload("res://entities/knife/knife.tscn")
@onready var gold_knife_scene = preload("res://entities/gold_knife/gold_knife.tscn")
@onready var jetpack_scene = preload("res://entities/jetpack/jetpack.tscn")
@onready var rng = RandomNumberGenerator.new()

@onready var player = $Player
@onready var dummy = $Dummy

var boxes : Array
var placeholders : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	player.spawn_position = player.global_position
	dummy.spawn_position = dummy.global_position
	
	placeholders.append($Placeholder1.global_position)
	placeholders.append($Placeholder2.global_position)
	placeholders.append($Placeholder3.global_position)
	placeholders.append($Placeholder4.global_position)
	placeholders.append($Placeholder5.global_position)
	placeholders.append($Placeholder6.global_position)
	placeholders.append($Placeholder7.global_position)
	placeholders.append($Placeholder8.global_position)
	placeholders.append($Placeholder9.global_position)
	placeholders.append($Placeholder10.global_position)
	placeholders.append($Placeholder11.global_position)
	spawn_entities()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dummy.set_physics_process(false)
	dummy.set_process_input(false)
	pass

func spawn_entities():
	# Spawn player
	#player = player_scene.instantiate()
	#add_child(player)
	#player.global_position = player.spawn_position
	
	# Spawn item boxes
	for i in range(placeholders.size()):
		boxes.append(item_box_scene.instantiate())
		boxes[i].connect("give_item", on_give_item)
		add_child(boxes[i])
		boxes[i].global_position = placeholders[i]
	pass

# Give player a random item.
# TODO: We need to pass a Player parameter that tells the function who to give the item to.
func on_give_item():
	# Only gives item if hands are empty
	if not player.get_node("Hand").get_child_count():
		var i = rng.randi_range(6, 6)
		match i:
			0:
				player.get_node("Hand").add_child(speed_boost_scene.instantiate())
			1:
				player.get_node("Hand").add_child(jump_boost_scene.instantiate())
			2:
				player.get_node("Hand").add_child(grav_cntrl_scene.instantiate())
			3:
				player.get_node("Hand").add_child(teleporter_scene.instantiate())
			4:
				player.get_node("Hand").add_child(jetpack_scene.instantiate())
			5:
				var bullet = bullet_scene.instantiate()
				bullet.state_scene = self
				player.get_node("Hand").add_child(bullet)
			6:
				var homing_bullet = homing_bullet_scene.instantiate()
				homing_bullet.state_scene = self
				player.get_node("Hand").add_child(homing_bullet)
			7:
				var knife = knife_scene.instantiate()
				knife.state_scene = self
				player.get_node("Hand").add_child(knife)
				$AudioStreamPlayer2D.stream = load("res://assets/sounds/knife-reverb-fx.wav")
				$AudioStreamPlayer2D.play(0.5)
			8:
				var gold_knife = gold_knife_scene.instantiate()
				gold_knife.state_scene = self
				player.get_node("Hand").add_child(gold_knife)
				$AudioStreamPlayer2D.stream = load("res://assets/sounds/71011-Sound_design_shimmer_accent_swell_airy_reverb_harmony-BLASTWAVEFX-07832.wav")
				$AudioStreamPlayer2D.play()
		print_debug("gave item")
	
