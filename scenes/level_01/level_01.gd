extends Node2D

var rope = preload("res://entities/rope/rope.tscn")
var start_pos := Vector2.ZERO
var end_pos := Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton and not event.is_pressed():
		if start_pos == Vector2.ZERO:
			start_pos = get_global_mouse_position()
		elif end_pos == Vector2.ZERO:
			end_pos = get_global_mouse_position()
			var r = rope.instantiate()
			add_child(r)
			r.get_node("ActualRope").spawn_rope(start_pos, end_pos)
			start_pos = Vector2.ZERO
			end_pos = Vector2.ZERO
