extends Node

@onready var ms = $MultiplayerSpawner2

var min_players = 1
var players_loaded = 0
var total_players = 0
var checking_interval = 1.0
var time_since_last_check = 0.0
var is_host = false
var level_loading_in_progress = false

func _ready():
	print("Ready function called.")
	if Steam.getLobbyOwner(Steam.getSteamID()):
		is_host = true
	ms.spawn_function = spawn_level
	print("Spawn function set to: ", ms.spawn_function)
	_check_player_count()

func _process(delta):
	time_since_last_check += delta
	if time_since_last_check >= checking_interval:
		time_since_last_check = 0.0
		_check_player_count()

func _check_player_count():
	print("Checking player count.")
	get_lobby_members()
	
	if total_players >= min_players and not level_loading_in_progress:
		print("Sufficient players in lobby. Loading level.")
		level_loading_in_progress = true
		_load_level("res://scenes/level_04/level_04.tscn")
	else:
		print("Not enough players to start the level.")

@rpc("call_local", "reliable")
func _load_level(level_path):
	$Control.queue_free()
	ms.spawn(level_path)
	_notify_player_loaded()

@rpc("any_peer", "call_local", "reliable")
func _notify_player_loaded():
	players_loaded += 1
	print("Player loaded. Total players loaded: ", players_loaded)
	
	if is_host:
		if players_loaded == total_players:
			print("All players loaded. Game ready to proceed.")
			level_loading_in_progress = false

func get_lobby_members():
	print("Getting lobby members.")
	total_players = Steam.getNumLobbyMembers(ColdStorage.lobby_id)
	
	if total_players == -1:
		print("Error: Failed to get number of lobby members.")
		total_players = 0
	else:
		print("Number of lobby members: ", total_players)

func _on_player_connected(id):
	_notify_player_loaded.rpc_id(id)

func spawn_level(data):
	var scene = load(data) as PackedScene
	return scene.instantiate()
