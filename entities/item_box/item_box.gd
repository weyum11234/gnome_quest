extends Node2D

@export var respawn_time = 5.0
var respawn_timer = 0.0
signal give_item

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("item_box_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Handle respawn
	if not visible and respawn_timer < respawn_time:
		respawn_timer += delta
	elif respawn_timer > respawn_time:
		visible = true
		$CollisionShape2D.disabled = false
		respawn_timer = 0.0

# Handle when player picks up an item box.
func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("give_item")
		$AnimationPlayer.play("item_box_explode")
	
# Play explosion animation, despawn box
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "item_box_explode":
		visible = false
		$CollisionShape2D.disabled = true
		$AnimationPlayer.play("item_box_idle")
		
