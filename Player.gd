extends CharacterBody2D


const ACCEL = 60.0

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("decelerate", "accelerate")
	if direction:
		velocity.x += delta * direction * ACCEL

	# TODO max speed

	move_and_slide()
