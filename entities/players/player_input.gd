extends MultiplayerSynchronizer

@export var jumping = false
@export var direction = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(is_multiplayer_authority())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not get_parent().is_on_floor():
		fall.rpc()
	
	if Input.is_action_just_pressed("ui_accept"):
		jump.rpc()
	
	direction = Input.get_axis("ui_left", "ui_right")


@rpc("call_local")
func jump():
	jumping = true

@rpc("call_local")
func fall():
	jumping = false
