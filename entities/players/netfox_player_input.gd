class_name NetfoxPlayerInput
extends Node

@onready var camera = $"../Camera2D"
@onready var hand = $"../Hand"

@export var direction = 0
var facing : int

@export var do_jump = false
@export var do_long_jump = false
@export var jumping = false

@export var do_use = false
@export var do_long_use = false
var mouse_pos : Vector2

# Timers.
@export var long_jump_time = 0.25
var long_jump_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	NetworkTime.before_tick_loop.connect(_gather)
	
	if is_multiplayer_authority():
		camera.make_current()
	else:
		set_process(false)
		
func _gather():
	if not is_multiplayer_authority():
		return
	
	# Handle walking.
	direction = Input.get_axis("left", "right")
	if direction:
		facing = direction
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_jump = Input.is_action_just_pressed("jump")
	do_long_jump = Input.is_action_pressed("jump")
	
	do_use = Input.is_action_just_pressed("use")
	do_long_use = Input.is_action_pressed("use")
