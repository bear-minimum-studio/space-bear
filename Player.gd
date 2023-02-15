extends CharacterBody2D


const ACCEL = 60.0
const ROTATION_SPEED = 0.005

func _physics_process(delta):
	var rotation_intensity = Input.get_axis("ui_left", "ui_right")
	self.rotation += rotation_intensity * ROTATION_SPEED
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var intensity = Input.get_axis("decelerate", "accelerate")
	if intensity:
		var v = delta * intensity * ACCEL
		velocity.x += v * sin(self.rotation)
		velocity.y += -v * cos(self.rotation)

	# TODO max speed

	move_and_slide()
