extends Node

# Called when the node enters the scene tree for the first time.

func _process(delta):
	var current_scene = get_tree().current_scene
	if current_scene != null:
		if current_scene.name == "MainMenu" or current_scene.name == "Settings":
			if $AudioStreamPlayer.playing == false:
				$AudioStreamPlayer.play()
		else:
			$AudioStreamPlayer.stop()
