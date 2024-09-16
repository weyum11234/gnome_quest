extends Control


@onready var pause_screen = $CanvasLayer
var is_paused = false
var in_settings = false

func _ready():
	$Settings/CanvasLayer.hide()
	mouse_filter = MOUSE_FILTER_IGNORE
	if SceneManager.is_paused:
		is_paused = !is_paused
		pause_screen.visible = is_paused
		mouse_filter = MOUSE_FILTER_IGNORE

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and in_settings == false:  # Escape key is usually mapped to "ui_cancel"
		toggle_pause()

func toggle_pause():
	SceneManager.is_paused = !SceneManager.is_paused
	is_paused = !is_paused
	
	# Uncomment if you wanna freeze the game when paused. I think it's better left unfrozen.
	#get_tree().paused = !get_tree().paused
	
	# Show or hide the pause screen.
	pause_screen.visible = is_paused 
	if pause_screen.visible:
		mouse_filter = MOUSE_FILTER_STOP
	else:
		mouse_filter = MOUSE_FILTER_IGNORE

func _on_resume_pressed():
	toggle_pause()

func _on_options_pressed():
	$CanvasLayer.hide()
	$Settings/CanvasLayer.show()
	in_settings = true

func hide_settings():
	$CanvasLayer.show()
	$Settings/CanvasLayer.hide()
	in_settings = false

func _on_quit_pressed():
	# Multiplayer stuff.
	# Don't really understand why this works?
	multiplayer.multiplayer_peer.disconnect_peer(1)
	
	# UI and tree stuff.
	toggle_pause()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
