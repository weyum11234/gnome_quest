extends Control


@onready var cont = $MarginContainer/HBoxContainer/VBoxContainer/Continue
@onready var new_game = $MarginContainer/HBoxContainer/VBoxContainer/NewGame
@onready var options = $MarginContainer/HBoxContainer/VBoxContainer/Options
@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/Exit


# Called when the node enters the scene tree for the first time.
func _ready():
	# Signal connections.
	cont.button_down.connect(on_cont_down)
	new_game.button_down.connect(on_ng_down)
	options.button_down.connect(on_options_down)
	exit.button_down.connect(on_exit_down)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_cont_down() -> void:
	pass
	
	
func on_ng_down() -> void:
	get_tree().change_scene_to_file("res://scenes/level_01/level_01.tscn")
	
	
func on_options_down() -> void:
	get_tree().change_scene_to_file("res://scenes/options/options.tscn")

	
func on_exit_down() -> void:
	get_tree().quit()

