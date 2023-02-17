extends Node2D

signal shoot

const ROTATION_SPEED = 2.0
const BULLETS_PER_SECOND = 5.0

const SHOOTING_SPEED = 1.0 / BULLETS_PER_SECOND 

var _reloading = false

func _shoot():
	if _reloading:
		return

	emit_signal("shoot")
	
	_reloading = true
	await get_tree().create_timer(SHOOTING_SPEED).timeout
	_reloading = false

func _physics_process(delta):
	var rotation_intensity = Input.get_axis("turret_left", "turret_right")
	self.rotation = self.rotation + rotation_intensity * ROTATION_SPEED * delta
	
	if (Input.is_action_pressed("turret_fire")):
		_shoot()
