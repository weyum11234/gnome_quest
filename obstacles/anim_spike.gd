extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.frame_changed.connect(_on_AnimatedSprite2D_frame_changed)
	$AnimatedSprite2D.play()  # Start playing the default animation

# Called when the AnimatedSprite2D's frame changes
func _on_AnimatedSprite2D_frame_changed():
	var animated_sprite = $AnimatedSprite2D
	if animated_sprite.frame == 0:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
