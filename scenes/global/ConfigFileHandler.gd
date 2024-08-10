extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		# Keybinds
		config.set_value("keybinding", "left", "A")
		config.set_value("keybinding", "right", "D")
		config.set_value("keybinding", "jump", "W")
		config.set_value("keybinding", "left2", "Left")
		config.set_value("keybinding", "right2", "Right")
		config.set_value("keybinding", "jump2", "Up")
		
		# Video
		config.set_value("video", "fullscreen", false)
		config.set_value("video", "aspect_ratio", "16:9")
		config.set_value("video", "vsync", "enabled")
		config.set_value("video", "resolution", "1920x1080")
		
		# Audio
		config.set_value("audio", "master_volume", 0.8)
		
		# FPS
		config.set_value("fps", "limit", 60)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
	
func save_video_setting(key: String, value):
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings

func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings

func save_fps_setting(value: int):
	config.set_value("fps", "limit", value)
	config.save(SETTINGS_FILE_PATH)

func load_fps_setting() -> int:
	return config.get_value("fps", "limit", 60)
