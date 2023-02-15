extends CharacterBody2D

signal shoot

const ACCEL = 90.0
const ROTATION_SPEED = 0.04

func _physics_process(delta):
	var rotation_intensity = Input.get_axis("turn_left", "turn_right")
	self.rotation += rotation_intensity * ROTATION_SPEED
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var intensity = Input.get_axis("decelerate", "accelerate")
	if intensity:
		var v = delta * intensity * ACCEL
		velocity.x += v * cos(self.rotation)
		velocity.y += v * sin(self.rotation)

	if (Input.is_action_pressed("fire")):
		emit_signal("shoot", global_position, global_rotation)
		
	# TODO max speed

	move_and_slide()
