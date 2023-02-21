extends RigidBody2D

signal shoot
signal shoot_grappling_hook

@export_range(0.0,500.0,5.0,"or_greater") var max_speed = 400.0
@export_range(0.0,3.0,0.05,"or_greater") var time_to_max_speed = 1.0
@export_range(0.0,4.0,0.1,"or_greater") var max_rotation_per_second = 0.7
@export_range(0.0,2.0,0.01,"or_greater") var time_to_max_rotation_speed = 0.07

@export_range(1,100) var max_health : int = 10
@export_range(0.5,50.0) var bullets_per_second = 5.0

@onready var max_rotation_speed = 2 * PI * max_rotation_per_second
@onready var health = max_health
@onready var shooting_speed = 1.0 / bullets_per_second
const HOOK_COOLDOWN = 1.0

var _reloading = false
var _reloading_hook = false

var thrust_friction_ratio :
	get: return mass / time_to_max_speed

var thrust_intensity :
	get: return max_speed * thrust_friction_ratio

var torque_friction_ratio :
	get: return inertia / time_to_max_rotation_speed

var torque_intensity :
	get: return max_rotation_speed * torque_friction_ratio

@onready var flammes = $Flammes
@onready var sfx = $SFX
@onready var turret_control = $Turret/TurretControl
@onready var turret = $Turret
@onready var turret_nozzle = $Turret/TurretControl/Nozzle

func _shoot():
	if _reloading:
		return

	emit_signal("shoot", global_position, global_rotation, linear_velocity)
	
	_reloading = true
	await get_tree().create_timer(shooting_speed).timeout
	_reloading = false

func _shoot_hook():
	if _reloading_hook:
		return

	emit_signal("shoot_grappling_hook", turret_nozzle.global_position, turret_control.global_rotation)
	
	_reloading_hook = true
	await get_tree().create_timer(HOOK_COOLDOWN).timeout
	_reloading_hook = false

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
	if (Input.is_action_pressed("grappling_hook")):
		_shoot_hook()

func _on_turret_control_shoot():
	emit_signal("shoot", turret_control.global_position, turret_control.global_rotation, linear_velocity)

func on_hit():
	health -= 1
	Events.emit_signal("player_hp_changed", health, max_health)
