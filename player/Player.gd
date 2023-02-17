extends CharacterBody2D

signal shoot

const ACCEL = 90.0
const ROTATION_SPEED = 0.04
const MAX_SPEED = 400
const BULLETS_PER_SECOND = 5.0

const SHOOTING_SPEED = 1.0 / BULLETS_PER_SECOND 

var _reloading = false

@onready var flammes = $Flammes
@onready var sfx = $SFX
@onready var turret_control = $Turret/TurretControl

func _shoot():
	if _reloading:
		return

	emit_signal("shoot", global_position, global_rotation, velocity)
	
	_reloading = true
	await get_tree().create_timer(SHOOTING_SPEED).timeout
	_reloading = false

func _custom_set_rotation(rotation_value: float):
	self.rotation = rotation_value
	$Turret.rotation = -self.rotation

func _physics_process(delta):
	var rotation_intensity = Input.get_axis("turn_left", "turn_right")
	_custom_set_rotation(self.rotation + rotation_intensity * ROTATION_SPEED)
	
	var intensity = Input.get_axis("decelerate", "accelerate")
	if intensity:
		var v = delta * intensity * ACCEL
		velocity.x += v * cos(self.rotation)
		velocity.y += v * sin(self.rotation)
		flammes.visible = true
		sfx.play()
	else:
		flammes.visible = false
		sfx.stop()
	
	if velocity.length() > MAX_SPEED:
		var max_x = abs(MAX_SPEED * cos(velocity.angle()))
		var max_y = abs(MAX_SPEED * sin(velocity.angle()))
		velocity.x = clamp(velocity.x, -max_x, max_x)
		velocity.y = clamp(velocity.y, -max_y, max_y)
		
	if (Input.is_action_pressed("fire")):
		_shoot()
		
	# TODO max speed

	move_and_slide()


func _on_turret_control_shoot():
	emit_signal("shoot", turret_control.global_position, turret_control.global_rotation, velocity)
