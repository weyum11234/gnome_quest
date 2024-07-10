extends Control


@onready var exit = $MarginContainer/VBoxContainer/Exit as Button


# Called when the node enters the scene tree for the first time.
func _ready():
	exit.button_down.connect(on_exit_down)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func on_exit_down() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

