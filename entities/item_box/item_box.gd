extends Node2D

@onready var collider = $CollisionShape2D
@onready var animation = $AnimationPlayer
@onready var respawn_timer = $RespawnTimer
static var rng = RandomNumberGenerator.new()

func give_item(body):
	if body.is_in_group("player"):
		if not body.get_node("Hand").get_child_count():
			var i = rng.randi_range(4, 4)
			match i:
				0:
					body.get_node("Hand").add_child(load("res://entities/speed_boost/speed_boost.tscn").instantiate(), true)
				1:
					body.get_node("Hand").add_child(load("res://entities/jump_boost/jump_boost.tscn").instantiate(), true)
				2:
					body.get_node("Hand").add_child(load("res://entities/gravity_controller/gravity_controller.tscn").instantiate())
				3:
					body.get_node("Hand").add_child(load("res://entities/jetpack/jetpack.tscn").instantiate())
				4:
					var fake_knife = load("res://entities/knife/knife_placeholder.tscn").instantiate()
					fake_knife.id = rng.randi()
					fake_knife.parent = get_parent()
					body.get_node("Hand").add_child(fake_knife)
				5:
					var fake_bullet = load("res://entities/bullet/bullet_placeholder.tscn").instantiate()
					fake_bullet.id = rng.randi()
					fake_bullet.parent = get_parent()
					body.get_node("Hand").add_child(fake_bullet)
				6:
					var fake_homing = load("res://entities/homing_bullet/homing_placeholder.tscn").instantiate()
					fake_homing.id = rng.randi()
					fake_homing.parent = get_parent()
					body.get_node("Hand").add_child(fake_homing)
		animation.play("item_box_explode")

func _ready():
	animation.play("item_box_idle")

func _on_body_entered(body):
	if not is_multiplayer_authority():
		return
		
	give_item.call_deferred(body)

# Despawn box.
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "item_box_explode":
		visible = false
		collider.disabled = true
		animation.play("item_box_idle")
		respawn_timer.start()
		
# Respawn box.
func _on_respawn_timer_timeout():
	visible = true
	collider.disabled = false
