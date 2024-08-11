extends Control

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

@onready var ms = $MultiplayerSpawner


func _ready():
	ms.spawn_function = spawn_level
	peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	$LobbyContainer.hide()
	$VBoxContainer3/Back.hide()
	open_lobby_list()
	

func spawn_level(data):
	var a = (load(data) as PackedScene).instantiate()
	return a
	
func _on_public_pressed():
	$VBoxContainer/Label2.hide()
	$VBoxContainer/private.hide()
	$VBoxContainer/public.hide()
	$VBoxContainer/host.hide()
	$VBoxContainer2/Exit.hide()
	$LobbyContainer.show()
	$VBoxContainer3/Back.show()
	
func _on_host_pressed():
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	ms.spawn("res://scenes/level_04/level_04.tscn")
	$".".hide()
	
func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	$".".hide()
	$LobbyContainer/Lobbies.hide()
	
	
func _on_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(lobby_id, "name", str(Steam.getPersonaName()+ "'S Lobby"))
		Steam.setLobbyJoinable(lobby_id, true)
		print(lobby_id)
		
func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()

func _on_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var memb_count = Steam.getNumLobbyMembers(lobby)
		var but = Button.new()
		but.set_text(str(lobby_name, "| Player Count: ", memb_count))
		but.set_size(Vector2(100, 5))
		but.connect("pressed", Callable(self, "join_lobby").bind(lobby))
		$LobbyContainer/Lobbies.add_child(but)


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished


func _on_back_pressed():
	$LobbyContainer.hide()
	$VBoxContainer3/Back.hide()
	$VBoxContainer/Label2.show()
	$VBoxContainer/private.show()
	$VBoxContainer/public.show()
	$VBoxContainer/host.show()
	$VBoxContainer2/Exit.show()
	

