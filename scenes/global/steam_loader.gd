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
	
	var id = Steam.getSteamID()
	var name = Steam.getFriendPersonaName(id)
	print("Username: ", str(name))
	
func _process(delta):
	Steam.run_callbacks()
