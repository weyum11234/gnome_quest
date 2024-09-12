extends Node

func _init():
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamAppID", str(480))
	
func _ready():
	Steam.steamInitEx()
	var isRunning = Steam.isSteamRunning()

	if !isRunning:
		print("ERROR: Steam not running!")
		return
	print("Steam is running!")
	
	var steam_id = Steam.getSteamID()
	var steam_name = Steam.getFriendPersonaName(steam_id)
	print(steam_id, steam_name)
	
func _process(_delta):
	Steam.run_callbacks()
