extends CharacterBody2D

signal shoot
signal shoot_grappling_hook

const ACCEL = 90.0
const ROTATION_SPEED = 2.0
const MAX_SPEED = 400
const BULLETS_PER_SECOND = 5.0
const MAX_HEALTH = 10

const SHOOTING_SPEED = 1.0 / BULLETS_PER_SECOND 
const HOOK_COOLDOWN = 1.0

var _reloading = false
var _reloading_hook = false
var health = MAX_HEALTH

@onready var flammes = $Flammes
@onready var sfx = $SFX
@onready var turret_control = $Turret/TurretControl
@onready var turret = $Turret
@onready var turret_nozzle = $Turret/TurretControl/Nozzle

func _shoot():
	if _reloading:
		return

	emit_signal("shoot", global_position, global_rotation, velocity)
	
	_reloading = true
	await get_tree().create_timer(SHOOTING_SPEED).timeout
	_reloading = false

func _shoot_hook():
	if _reloading_hook:
		return

	emit_signal("shoot_grappling_hook", turret_nozzle.global_position, turret_control.global_rotation, velocity)
	
	_reloading_hook = true
	await get_tree().create_timer(HOOK_COOLDOWN).timeout
	_reloading_hook = false

func _custom_set_rotation(rotation_value: float):
	self.rotation = rotation_value
	turret.rotation = -self.rotation

func _physics_process(delta):
	var rotation_intensity = Input.get_axis("turn_left", "turn_right")
	_custom_set_rotation(self.rotation + rotation_intensity * ROTATION_SPEED * delta)
	
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
	if (Input.is_action_pressed("grappling_hook")):
		_shoot_hook()

	move_and_slide()


func _on_turret_control_shoot():
	emit_signal("shoot", turret_control.global_position, turret_control.global_rotation, velocity)

func on_hit():
	health -= 1
	Events.emit_signal("player_hp_changed", health, MAX_HEALTH)
