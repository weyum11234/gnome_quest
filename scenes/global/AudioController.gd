extends Node

# Called when the node enters the scene tree for the first time.

func _process(delta):
	var current_scene = get_tree().current_scene
	if current_scene != null:
		var play_scenes = ["MainMenu", "Settings", "join_lobby"]
		if current_scene.name in play_scenes:
			if not $AudioStreamPlayer.playing:
				$AudioStreamPlayer.play()
		else:
			$AudioStreamPlayer.stop()
