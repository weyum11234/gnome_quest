extends MultiplayerSpawner

@onready var PlayerScene = preload("res://entities/players/player.tscn")

var players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = spawnPlayer
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(removePlayer)

# Spawns a player instance and adds it to the scene tree with replication.
func spawnPlayer(data):
	var p = PlayerScene.instantiate()
	p.set_multiplayer_authority(data)
	players[data] = p
	return p

# Removes a player instance from the scene tree.
func removePlayer(data):
	players[data].queue_free()
	players.erase(data)
