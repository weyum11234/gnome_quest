extends Node2D

@onready var collider = $CollisionShape2D
@onready var animation = $AnimationPlayer
@onready var respawn_timer = $RespawnTimer
@onready var rng = RandomNumberGenerator.new()

func give_item(body):
	if body.is_in_group("player"):
		if not body.get_node("Hand").get_child_count():
			var i = rng.randi_range(7, 7)
			match i:
				0:
					body.get_node("Hand").add_child(load("res://entities/speed_boost/speed_boost.tscn").instantiate())
				1:
					body.get_node("Hand").add_child(load("res://entities/jump_boost/jump_boost.tscn").instantiate())
				2:
					body.get_node("Hand").add_child(load("res://entities/gravity_controller/gravity_controller.tscn").instantiate())
				3:
					body.get_node("Hand").add_child(load("res://entities/teleporter/teleporter.tscn").instantiate())
				4:
					body.get_node("Hand").add_child(load("res://entities/jetpack/jetpack.tscn").instantiate())
				5:
					var bullet = load("res://entities/bullet/bullet.tscn").instantiate()
					bullet.state_scene = get_parent()
					body.get_node("Hand").add_child(bullet)
				6:
					var homing_bullet = load("res://entities/homing_bullet/homing_bullet.tscn").instantiate()
					homing_bullet.state_scene = get_parent()
					body.get_node("Hand").add_child(homing_bullet)
				7:
					var knife = load("res://entities/knife/knife.tscn").instantiate()
					knife.state_scene = get_parent()
					body.get_node("Hand").add_child(knife)
					$AudioStreamPlayer2D.stream = load("res://assets/sounds/knife-reverb-fx.wav")
					$AudioStreamPlayer2D.play(0.5)
				8:
					var gold_knife = load("res://entities/gold_knife/gold_knife.tscn").instantiate()
					gold_knife.state_scene = get_parent()
					body.get_node("Hand").add_child(gold_knife)
					$AudioStreamPlayer2D.stream = load("res://assets/sounds/71011-Sound_design_shimmer_accent_swell_airy_reverb_harmony-BLASTWAVEFX-07832.wav")
					$AudioStreamPlayer2D.play()
		animation.play("item_box_explode")

func _ready():
	animation.play("item_box_idle")

func _on_body_entered(body):
	call_deferred("give_item", body)

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
