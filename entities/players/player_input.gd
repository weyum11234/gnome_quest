extends MultiplayerSynchronizer

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
	if is_multiplayer_authority():
		camera.make_current()
	else:
		set_process(false)
		set_physics_process(false)
		

func _process(delta):
	# Handle item.
	if Input.is_action_just_pressed("use"):
		use.rpc()
	if Input.is_action_pressed("use"):
		long_use.rpc()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Resetting default values.
	do_jump = false
	do_long_jump = false
	do_use = false
	do_long_use = false
	mouse_pos = get_parent().get_global_mouse_position()
	
	# Handle walking.
	direction = Input.get_axis("left", "right")
	if direction:
		facing = direction
	
	# Handle jumping.
	if Input.is_action_just_pressed("jump"):
		jump.rpc()
	if Input.is_action_pressed("jump"):
		long_jump.rpc()
		
@rpc("call_local")
func jump():
	do_jump = true

@rpc("call_local")
func long_jump():
	do_long_jump = true

@rpc("call_local")
func use():
	do_use = true

@rpc("call_local")
func long_use():
	do_long_use = true
