extends Control


@onready var new_game = $MarginContainer/HBoxContainer/VBoxContainer/NewGame
@onready var item_list = $MarginContainer/HBoxContainer/VBoxContainer/ItemList
@onready var options = $MarginContainer/HBoxContainer/VBoxContainer/Options
@onready var exit = $MarginContainer/HBoxContainer/VBoxContainer/Exit


# Called when the node enters the scene tree for the first time.
func _ready():
	new_game.button_down.connect(on_ng_down)
	item_list.button_down.connect(on_il_down)
	options.button_down.connect(on_options_down)
	exit.button_down.connect(on_exit_down)


func on_ng_down() -> void:
	get_tree().change_scene_to_file("res://scenes/startup/startup.tscn")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	
	
func on_il_down() -> void:
	get_tree().change_scene_to_file("res://scenes/item_list/item_list.tscn")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	
	
func on_options_down() -> void:
	get_tree().change_scene_to_file("res://scenes/options/settings.tscn")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished

	
func on_exit_down() -> void:
	get_tree().quit()

