extends RigidBody2D

signal shoot

# TODO : FineTune Parameters
const MAX_SPEED = 400.0
const TIME_TO_MAX_SPEED = 1.0
const MAX_ROTATION_SPEED = 2*PI
const TIME_TO_MAX_ROTATION_SPEED = 0.5

@export_range(1,100) var max_health : int = 10
@export_range(0.5,50.0) var bullets_per_second = 5.0

@onready var health = max_health
@onready var shooting_speed = 1.0 / bullets_per_second

var _reloading = false

var thrust_friction_ratio = mass / TIME_TO_MAX_SPEED
var thrust_intensity = MAX_SPEED * thrust_friction_ratio
var torque_friction_ratio = inertia / TIME_TO_MAX_ROTATION_SPEED
var torque_intensity = MAX_ROTATION_SPEED * torque_friction_ratio

@onready var flammes = $Flammes
@onready var sfx = $SFX
@onready var turret_control = $Turret/TurretControl
@onready var turret = $Turret

func _shoot():
	if _reloading:
		return

	emit_signal("shoot", global_position, global_rotation, linear_velocity)
	
	_reloading = true
	await get_tree().create_timer(shooting_speed).timeout
	_reloading = false

func _custom_set_rotation():
	turret.rotation = -self.rotation

func _integrate_forces(state):
	_thrust(state)
	_torque(state)
	_custom_set_rotation()
		
func _thrust(state):
	var thrust_friction = - thrust_friction_ratio * linear_velocity
	state.apply_central_force(thrust_friction)
	var intensity = Input.get_axis("decelerate", "accelerate")
	var thrust = intensity * thrust_intensity * Vector2.from_angle(rotation)
	state.apply_central_force(thrust)
	if intensity:
		flammes.visible = true
		sfx.play()
	else:
		flammes.visible = false
		sfx.stop()
	
func _torque(state):
	var intensity = Input.get_axis("turn_left", "turn_right")
	var torque = intensity * torque_intensity
	state.apply_torque(torque)
	var torque_friction = - torque_friction_ratio * angular_velocity
	state.apply_torque(torque_friction)

func _physics_process(_delta):
	if (Input.is_action_pressed("fire")):
		_shoot()

func _on_turret_control_shoot():
	emit_signal("shoot", turret_control.global_position, turret_control.global_rotation, linear_velocity)

func on_hit():
	health -= 1
	Events.emit_signal("player_hp_changed", health, max_health)
