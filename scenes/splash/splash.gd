extends Node2D

@onready var title = $Title
@onready var crack = $Crack
@onready var end = $End
const SPEED = 460

# Called when the node enters the scene tree for the first time.
func _ready():
	crack.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	title.position = title.position.move_toward(end.position, SPEED * delta)
	if title.position == end.position and not crack.visible:
		crack.visible = true

func _input(event):
	if event is InputEvent and event.is_pressed():
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
