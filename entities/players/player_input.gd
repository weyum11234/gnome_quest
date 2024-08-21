extends MultiplayerSynchronizer

@onready var camera = $"../Camera2D"
@onready var hand = $"../Hand"

@export var do_jump = false
@export var do_long_jump = false
@export var jumping = false
@export var direction = 0

@export var do_use = false

# Timers.
@export var long_jump_time = 0.25
var long_jump_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_multiplayer_authority():
		camera.make_current()
	else:
		set_process(false)
		set_process_input(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Resetting default values.
	do_jump = false
	do_long_jump = false
	do_use = false
	
	# Handle walking.
	direction = Input.get_axis("left", "right")
	
	# Handle jumping
	if Input.is_action_just_pressed("jump"):
		jump.rpc()
	if Input.is_action_pressed("jump"):
		long_jump.rpc()
		

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and hand.get_children():
			do_use = true

@rpc("call_local")
func jump():
	do_jump = true

@rpc("call_local")
func long_jump():
	do_long_jump = true
