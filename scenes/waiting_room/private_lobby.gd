#manas
extends Node

@onready var ms = $MultiplayerSpawner2

var min_players = 2
var lobby_members = []
var players_fully_loaded = {}
var checking_interval = 1.0  # Interval in seconds for checking player count
var time_since_last_check = 0.0

func _ready():
	print("Ready function called.")
	_check_player_count()

func _process(delta):
	time_since_last_check += delta
	if time_since_last_check >= checking_interval:
		time_since_last_check = 0.0
		_check_player_count()

func _check_player_count():
	print("Checking player count.")
	get_lobby_members()
	if lobby_members.size() >= min_players:
		print("Sufficient players in lobby. Waiting for players to load.")
		_wait_for_players_to_load()
	else:
		print("Not enough players to start the level.")

func _wait_for_players_to_load():
	print("Waiting for players to load.")
	for member in lobby_members:
		var player_id = member["steam_id"]
		players_fully_loaded[player_id] = false
		Steam.setLobbyMemberData(ColdStorage.lobby_id, "player_loading_" + str(player_id), "true")
		print("Setting player_loading data for player_id:", player_id)

	multiplayer.connect("player_loaded", Callable(self, "_on_player_loaded"))

func spawn_level(data):
	print("Spawning level with data:", data)
	var level_instance = (load(data) as PackedScene).instantiate()
	add_child(level_instance)
	return level_instance

func _on_player_loaded(player_id):
	print("Player loaded:", player_id)
	players_fully_loaded[player_id] = true
	Steam.setLobbyMemberData(ColdStorage.lobby_id, "player_loaded_" + str(player_id), "true")
	_check_all_players_loaded()

func _check_all_players_loaded():
	print("Checking if all players are loaded.")
	for player_id in players_fully_loaded.keys():
		if not players_fully_loaded[player_id]:
			print("Player not yet fully loaded:", player_id)
			return

	print("All players loaded. Spawning level.")
	ms.spawn("res://scenes/level_04/level_04.tscn")

func get_lobby_members() -> void:
	print("Getting lobby members.")
	lobby_members.clear()
	var num_of_members: int = Steam.getNumLobbyMembers(ColdStorage.lobby_id)
	if num_of_members == -1:
		print("Error: Failed to get number of lobby members.")
		return

	print("Number of lobby members:", num_of_members)
	for this_member in range(num_of_members):
		var member_steam_id: int = Steam.getLobbyMemberByIndex(ColdStorage.lobby_id, this_member)
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)
		lobby_members.append({"steam_id": member_steam_id, "steam_name": member_steam_name})
		print("Member added:", member_steam_id, member_steam_name)
