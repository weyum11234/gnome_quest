extends Node2D

@onready var first_scene = preload("res://scenes/test_stage/test_stage.tscn")
@onready var peer = SteamMultiplayerPeer.new()
var lobby_id : int

# Called when the node enters the scene tree for the first time.
func _ready():
	peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	get_lobby_list()

func _on_private_pressed():
	print("private")
	# TODO: add private functionality

func _on_public_pressed():
	$UI/VBoxContainer/Private.hide()
	$UI/VBoxContainer/Public.hide()
	$UI/VBoxContainer/Host.hide()
	$UI/LobbiesList.show()
	$UI/Refresh.show()

func _on_host_pressed():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	start_game()

func _on_refresh_pressed():
	if $UI/LobbiesList/Lobbies.get_child_count():
		# Clear lobbies
		for lobby in $UI/LobbiesList/Lobbies.get_children():
			lobby.queue_free()
		# Repopulate
		get_lobby_list()

func _on_back_pressed():
	if $UI/LobbiesList.is_visible_in_tree():
		$UI/VBoxContainer/Private.show()
		$UI/VBoxContainer/Public.show()
		$UI/VBoxContainer/Host.show()
		$UI/LobbiesList.hide()
		$UI/Refresh.hide()
	else:
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
	
func _on_lobby_match_list(lobbies : Array):
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var memb_count = Steam.getNumLobbyMembers(lobby)
		var lobby_button = Button.new()
		lobby_button.set_text(str(lobby_name, " | Player Count: ", memb_count))
		lobby_button.set_size(Vector2(100, 5))
		lobby_button.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		$UI/LobbiesList/Lobbies.add_child(lobby_button, true)

func _on_lobby_created(connect : int, l_id : int):
	if connect:
		lobby_id = l_id
		Steam.setLobbyJoinable(lobby_id, true)
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName() + " Lobby"))
	
func _on_lobby_join_requested(l_id : int, f_id : int):
	print_debug("Joining ", Steam.getFriendPersonaName(f_id), " Lobby")
	join_lobby(l_id)

func get_lobby_list():
	Steam.addRequestLobbyListStringFilter("name", "weyum", Steam.LOBBY_COMPARISON_EQUAL_TO_GREATER_THAN)
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_DEFAULT)
	Steam.requestLobbyList()

func join_lobby(l_id : int):
	lobby_id = l_id
	peer.connect_lobby(l_id)
	multiplayer.multiplayer_peer = peer
	start_game()

func start_game():
	$UI.hide()
	if is_multiplayer_authority():
		change_level.call_deferred(first_scene)
		
func change_level(scene : PackedScene):
	var level = $Level
	# Clean up first
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Spawn level
	level.add_child(scene.instantiate())

