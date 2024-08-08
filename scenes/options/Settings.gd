extends Control

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
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

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
