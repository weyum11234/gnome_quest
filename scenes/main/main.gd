extends Node

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()
@onready var menu = $Menu
@onready var ms = $MultiplayerSpawner
@onready var cont = $Menu/MarginContainer/HBoxContainer/VBoxContainer/Continue
@onready var new_game = $Menu/MarginContainer/HBoxContainer/VBoxContainer/NewGame
@onready var options = $Menu/MarginContainer/HBoxContainer/VBoxContainer/Options
@onready var exit = $Menu/MarginContainer/HBoxContainer/VBoxContainer/Exit


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamGameID", str(480))
	Steam.steamInitEx()
	cont.button_down.connect(on_cont_down)
	new_game.button_down.connect(on_ng_down)
	options.button_down.connect(on_options_down)
	exit.button_down.connect(on_exit_down)
	ms.spawn_function = spawn_level
	peer.lobby_created.connect(_on_lobby_created)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Steam.run_callbacks()
	

func spawn_level(data):
	var a = (load(data) as PackedScene).instantiate()
	return a

func on_cont_down() -> void:
	pass
	
	
func on_ng_down() -> void:
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	ms.spawn("res://scenes/level_01/level_01.tscn")
	menu.hide()
	
	
func on_options_down() -> void:
	get_tree().change_scene_to_file("res://scenes/options/options.tscn")

	
func on_exit_down() -> void:
	get_tree().quit()

func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	menu.hide()

func _on_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName()+"'s Lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		print(lobby_id)
		
func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_DEFAULT)
	Steam.requestLobbyList()
	
func on_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var mem_count = Steam.getNumLobbyMembers(lobby)
		
