extends Node2D

const PORT = 8080

func start_game():
	$UI.hide()
	if multiplayer.is_server():
		change_level.call_deferred(load("res://scenes/test_stage/test_stage.tscn"))
		
func change_level(scene : PackedScene):
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	level.add_child(scene.instantiate())

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_host_pressed():
	print("hosting")
	# Creating server.
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	start_game()

func _on_public_pressed():
	print("joining")
	# Create client.
	var ip = "127.0.0.1"
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	start_game()
