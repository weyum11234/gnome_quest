extends Node2D

var id : int
var parent : Node

func use(player : Object):
	var real_knife = load("res://entities/knife/knife.tscn").instantiate()
	real_knife.set_values(id, player)
	parent.add_child(real_knife)
	queue_free()

func reset():
	queue_free()
