extends Node

func _ready():
	load_settings()

func load_settings():
	# Load video settings
	var video_settings = ConfigFileHandler.load_video_settings()
	var resolution = video_settings["resolution"].split("x")
	var width = resolution[0].to_int()
	var height = resolution[1].to_int()
	DisplayServer.window_set_size(Vector2i(width, height))
	
	if video_settings["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if video_settings["vsync"] == "enabled":
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	elif video_settings["vsync"] == "adaptive":
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	# Load audio settings
	var audio_settings = ConfigFileHandler.load_audio_settings()
	AudioServer.set_bus_volume_db(0, audio_settings["master_volume"])

	# Load FPS setting
	Engine.max_fps = ConfigFileHandler.load_fps_setting()
