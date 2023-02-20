extends RigidBody2D

signal shoot

const THRUST = 200.0
const THRUST_FRICTION = 0.5
const TORQUE = 25000.0
const TORQUE_FRICTION = 10000
const BULLETS_PER_SECOND = 5.0
const MAX_HEALTH = 10

const SHOOTING_SPEED = 1.0 / BULLETS_PER_SECOND 

var _reloading = false
var health = MAX_HEALTH

@onready var flammes = $Flammes
@onready var sfx = $SFX
@onready var turret_control = $Turret/TurretControl
@onready var turret = $Turret

func _shoot():
	if _reloading:
		return

	emit_signal("shoot", global_position, global_rotation, linear_velocity)
	
	_reloading = true
	await get_tree().create_timer(SHOOTING_SPEED).timeout
	_reloading = false

func _custom_set_rotation():
	turret.rotation = -self.rotation

func _integrate_forces(state):
	_thrust(state)
	_torque(state)
	_custom_set_rotation()
		
func _thrust(state):
	var intensity = Input.get_axis("decelerate", "accelerate")
	if intensity:
		var thrust = intensity * THRUST * Vector2.from_angle(rotation)
		state.apply_central_force(thrust)
		var thrust_friction = - THRUST_FRICTION * linear_velocity
		state.apply_central_force(thrust_friction)
		flammes.visible = true
		sfx.play()
	else:
		flammes.visible = false
		sfx.stop()
	
func _torque(state):
	var intensity = Input.get_axis("turn_left", "turn_right")
	var torque = intensity * TORQUE
	state.apply_torque(torque)
	var torque_friction = - TORQUE_FRICTION * angular_velocity
	state.apply_torque(torque_friction)

func _physics_process(_delta):
	if (Input.is_action_pressed("fire")):
		_shoot()

func _on_turret_control_shoot():
	emit_signal("shoot", turret_control.global_position, turret_control.global_rotation, linear_velocity)

func on_hit():
	health -= 1
	Events.emit_signal("player_hp_changed", health, MAX_HEALTH)
