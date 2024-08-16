extends Node2D

@onready var player_scene = preload("res://entities/players/player.tscn")

func _ready():
	if not is_multiplayer_authority():
		return
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)
	
	for id in multiplayer.get_peers():
		add_player(id)
		
	if not OS.has_feature("dedicated_server"):
		add_player(1)

func _exit_tree():
	if not multiplayer.is_server():
		return
		
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)
	
func add_player(id : int):
	var player = player_scene.instantiate()
	player.player_id = id
	player.name = str(id)
	
	var pos = Vector2.ZERO
	player.position = pos
	$Players.add_child(player, true)
	
	
func del_player(id : int):
	if not $Players.has_node(str(id)):
		return
		
	$Players.get_node(str(id)).queue_free()
