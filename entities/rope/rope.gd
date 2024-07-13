extends Node2D

const ROPE_PIECE_LENGTH = 2.0
const ROPE_CLOSE_TOLERANCE = 2.0
var rope_piece = preload("res://entities/rope/rope_piece.tscn")
var rope_parts = []
var rope_points = []
var rope_colors = []

@onready var start_piece = $RopeStartPiece
@onready var end_piece = $RopeEndPiece
@onready var start_joint = $RopeStartPiece/Collision/Joint
@onready var end_joint = $RopeEndPiece/Collision/Joint


func _process(delta):
	get_points()
	if not rope_points.is_empty():
		queue_redraw()


func spawn_rope(start_pos : Vector2, end_pos : Vector2):
	start_piece.global_position = start_pos
	end_piece.global_position = end_pos
	start_pos = start_joint.global_position
	end_pos = end_joint.global_position
	
	var distance = start_pos.distance_to(end_pos)
	var segment_count = round(distance / ROPE_PIECE_LENGTH)
	var spawn_angle = (end_pos - start_pos).angle() - PI / 2
	create_rope(segment_count, start_piece, end_pos, spawn_angle)


func create_rope(segment_count : int, parent : Object, end_pos : Vector2, spawn_angle : float):
	rope_colors.append(Color("#884b2b"))
	for i in segment_count:
		rope_colors.append(Color("#884b2b"))
		parent = add_piece(parent, i , spawn_angle)
		rope_parts.append(parent)
		
		var joint_pos = parent.get_node("Collision/Joint").global_position
		if joint_pos.distance_to(end_pos) < ROPE_CLOSE_TOLERANCE:
			break
	
	rope_colors.append(Color("#884b2b"))
	end_joint.node_a = end_piece.get_path()
	end_joint.node_b = rope_parts[-1].get_path()
	

func add_piece(parent : Object, id : int, spawn_angle : float) -> Object:
	var joint : PinJoint2D = parent.get_node("Collision/Joint") as PinJoint2D
	var piece : Object = rope_piece.instantiate() as Object
	piece.global_position = joint.global_position
	piece.rotation = spawn_angle
	piece.parent = self
	piece.id = id
	add_child(piece)
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	return piece
	
func get_points():
	rope_points.clear()
	rope_points.append(start_joint.global_position)
	for r in rope_parts:
		rope_points.append(r.global_position)
	rope_points.append(end_joint.global_position)
	

func _draw():
	draw_polyline_colors(rope_points, rope_colors, 0.6, false)
