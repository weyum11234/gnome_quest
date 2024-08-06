extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var current_scene = get_tree().current_scene
	if current_scene != null:
		print(current_scene.name)
		if current_scene.name == "MainMenu" or "Settings":
			if $AudioStreamPlayer.playing == false:
				$AudioStreamPlayer.play()
		else:
			$AudioStreamPlayer.stop()
	
