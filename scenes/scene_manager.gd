extends Node

var previous_scene
var is_paused = false

func go_to_scene(scene_path: String):
	previous_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(scene_path)
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	

func go_back():
	if previous_scene:
		var last_scene = previous_scene
		previous_scene = null  # Clear to avoid circular references
		get_tree().change_scene_to_file(last_scene)
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
