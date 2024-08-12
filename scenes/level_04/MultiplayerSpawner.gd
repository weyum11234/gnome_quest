extends MultiplayerSpawner

@onready var PlayerScene = preload("res://entities/players/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("yeety")
	spawn_function = spawnPlayer
	if is_multiplayer_authority():
		print("???")
		spawn(1)
		print("HUHUHUHUH")
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(removePlayer)
var players = {}

# Spawns a player instance and adds it to the scene tree with replication.
func spawnPlayer(data):
	print("beety")
	var p = PlayerScene.instantiate()
	p.set_multiplayer_authority(data)
	players[data] = p
	#add_child(p, true)  # Ensure the node is added with replication
	return p

# Removes a player instance from the scene tree.
func removePlayer(data):
	players[data].queue_free()
	players.erase(data)
