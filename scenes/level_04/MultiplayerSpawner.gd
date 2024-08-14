extends MultiplayerSpawner

@onready var PlayerScene = preload("res://entities/players/player.tscn")

var players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = spawnPlayer # = spawn
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(removePlayer)

func _process(delta):
	print(get_spawnable_scene_count())
	print(get_children())

# Spawns a player instance and adds it automatically as a child of multiplayer spawner.
func spawnPlayer(data):
	print(data)
	var p = PlayerScene.instantiate()
	p.set_multiplayer_authority(data)
	players[data] = p
	return p

# Removes a player instance from the scene tree.
func removePlayer(data):
	players[data].queue_free()
	players.erase(data)
