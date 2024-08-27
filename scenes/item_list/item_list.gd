extends Control




func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
