extends Control


@onready var exit = $MarginContainer/VBoxContainer/Exit as Button
signal exit_options


# Called when the node enters the scene tree for the first time.
func _ready():
	exit.button_down.connect(on_exit_down)
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func on_exit_down() -> void:
	exit_options.emit()
	set_process(false)
