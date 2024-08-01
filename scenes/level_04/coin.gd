extends CharacterBody2D

# Called when the node enters the scene tree for the first time
func _ready():
	$AnimatedSprite2D.frame_changed.connect(_on_AnimatedSprite2D_frame_changed)
	$AnimatedSprite2D.play("default")
	

func _on_area_2d_area_entered(area):
	$AnimatedSprite2D.play("collected")
	


func _on_area_2d_body_entered(body):
	$AnimatedSprite2D.play("collected")
	
func _on_AnimatedSprite2D_frame_changed():
	var animated_sprite = $AnimatedSprite2D
	if animated_sprite.frame == 9:
		hide()
		stop_node()

func stop_node():
	set_process(false)  # Disable _process
	set_physics_process(false)  # Disable _physics_process
	set_process_input(false)  # Disable input processing
	set_block_signals(true)  # Block signals
		
