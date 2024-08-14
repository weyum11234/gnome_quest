extends Node2D


@export var speed = 200.0
@onready var emitter1 = $CPUParticles2D
@onready var emitter2 = $CPUParticles2D2


var player : Object
var flight_time = 2.0
var flight_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	emitter1.emitting = false
	emitter2.emitting = false
	$ProgressBar.max_value = flight_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flight_timer > flight_time or (player and player.animation == "respawn"):
		queue_free()
		
	if player and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		emitter1.emitting = true
		emitter2.emitting = true
		player.velocity.y = 0
		player.position.y -= speed * delta
		flight_timer += delta
		$ProgressBar.value += delta
	else:
		emitter1.emitting = false
		emitter2.emitting = false


func use(player : Object):
	self.player = player

func alt_use(player : Object):
	pass
	
func reset():
	queue_free()
