extends Control

@onready var resolution_option_button = $CanvasLayer/VBoxContainer/OptionButton
@onready var fullscreen_option_button = $CanvasLayer/VBoxContainer/OptionButton2
@onready var vsync_option_button = $CanvasLayer/VBoxContainer/OptionButton4
@onready var fps_option_button = $CanvasLayer/VBoxContainer/OptionButton3
@onready var master_volume_slider = $CanvasLayer/VBoxContainer/HSlider

func _ready():
	# Load and apply settings to UI elements
	apply_settings()

func apply_settings():
	# Apply video settings
	var video_settings = ConfigFileHandler.load_video_settings()
	var resolution = video_settings.get("resolution", "1920x1080").split("x")
	var width = resolution[0].to_int()
	var height = resolution[1].to_int()

	# Set resolution option button
	if width == 1920 and height == 1080:
		resolution_option_button.select(0)
	elif width == 1600 and height == 900:
		resolution_option_button.select(1)
	elif width == 1280 and height == 720:
		resolution_option_button.select(2)
	elif width == 640 and height == 360:
		resolution_option_button.select(3)

	# Set fullscreen option button
	if video_settings.get("fullscreen", false):
		fullscreen_option_button.select(0)
	else:
		fullscreen_option_button.select(1)

	# Set Vsync option button
	match video_settings.get("vsync", "enabled"):
		"enabled":
			vsync_option_button.select(0)
		"disabled":
			vsync_option_button.select(1)
		"adaptive":
			vsync_option_button.select(2)

	# Apply audio settings
	var audio_settings = ConfigFileHandler.load_audio_settings()
	master_volume_slider.value = audio_settings.get("master_volume", 0.8)

	# Apply FPS setting
	match ConfigFileHandler.load_fps_setting():
		30:
			fps_option_button.select(0)
		60:
			fps_option_button.select(1)
		144:
			fps_option_button.select(2)
		0:
			fps_option_button.select(3)


func _on_option_button_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			ConfigFileHandler.save_video_setting("resolution", "1920x1080")
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
			ConfigFileHandler.save_video_setting("resolution", "1600x900")
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))
			ConfigFileHandler.save_video_setting("resolution", "1280x720")
		3:
			DisplayServer.window_set_size(Vector2i(640, 360))
			ConfigFileHandler.save_video_setting("resolution", "640x360")

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	ConfigFileHandler.save_audio_settings("master_volume", value)

func _on_exit_pressed():
	get_parent().hide_settings()

func _on_option_button_2_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			ConfigFileHandler.save_video_setting("fullscreen", true)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			ConfigFileHandler.save_video_setting("fullscreen", false)

func _on_option_button_4_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			ConfigFileHandler.save_video_setting("vsync", "enabled")
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			ConfigFileHandler.save_video_setting("vsync", "disabled")
		2:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
			ConfigFileHandler.save_video_setting("vsync", "adaptive")

func _on_option_button_3_item_selected(index):
	match index:
		0:
			Engine.max_fps = 30
			ConfigFileHandler.save_fps_setting(30)
		1:
			Engine.max_fps = 60
			ConfigFileHandler.save_fps_setting(60)
		2:
			Engine.max_fps = 144
			ConfigFileHandler.save_fps_setting(144)
		3:
			Engine.max_fps = 0
			ConfigFileHandler.save_fps_setting(0)
