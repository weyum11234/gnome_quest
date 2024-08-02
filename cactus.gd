extends CharacterBody2D

@onready var spike = $Spike
@onready var firepoint = $firepoint

func _ready():
	$AnimatedSprite2D.play("default")
	shoot()
	
func shoot():
	if $AnimatedSprite2D.frame == 3:
		var spawned_spike = spike.instantiate()
		spawned_spike.direction = Vector2(firepoint.scale.x, 0) # Assuming the cannonball moves horizontally
		spawned_spike.global_position = firepoint.global_position # Use global_position to ensure correct positioning
		get_parent().add_child(spawned_spike) # Add the spawned spike to the parent node, not itself
