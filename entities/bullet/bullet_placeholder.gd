extends Node2D

var id : int
var parent : Node

func use(player : Object):
	var real_bullet = load("res://entities/bullet/bullet.tscn").instantiate()
	real_bullet.set_values(id, player)
	parent.add_child(real_bullet)
	queue_free()
