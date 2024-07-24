extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$EndPiece.global_position = get_global_mouse_position()
		$StartPiece.position = $StartPiece.position.move_toward($EndPiece.global_position, 100 * delta)
		queue_redraw()
		

func _draw():
	draw_line($StartPiece.global_position, $EndPiece.global_position, Color.BLACK, 1)
