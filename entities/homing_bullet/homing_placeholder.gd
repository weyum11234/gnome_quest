extends Node2D

var id : int
var parent : Node

func use(player : Object):
	var real_homing = load("res://entities/homing_bullet/homing_bullet.tscn").instantiate()
	real_homing.set_values(id, player, parent)
	parent.add_child(real_homing)
	queue_free()

func reset():
	queue_free()
