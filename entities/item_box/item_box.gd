extends Node2D

@onready var collider = $CollisionShape2D
@onready var animation = $AnimationPlayer
@onready var respawn = $Respawn
signal give_item

func _ready():
	animation.play("item_box_idle")

# Player picks up box.
func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("give_item")
		animation.play("item_box_explode")
	
# Despawn box.
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "item_box_explode":
		visible = false
		collider.disabled = true
		animation.play("item_box_idle")
		respawn.start()
		
# Respawn box.
func _on_timer_timeout():
	visible = true
	collider.disabled = false
