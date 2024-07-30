extends AnimatableBody2D

@export var counter_clockwise = 1 # 1 for clockwise, -1 for counter clockwise
@export var rotation_speed = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate(PI / rotation_speed * counter_clockwise)
	pass
