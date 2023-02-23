extends RigidBody2D

signal shoot_grappling_hook

@export_range(0.0,500.0,5.0,"or_greater") var max_speed = 200.0
@export_range(0.0,3.0,0.05,"or_greater") var time_to_max_speed = 1.0
@export_range(0.0,3.0,0.05,"or_greater") var time_to_stop = 0.7
@export_range(0.0,4.0,0.1,"or_greater") var rotation_per_second = 0.7

@export_range(1,100) var max_health : int = 10
@export_range(0.5,50.0) var bullets_per_second = 5.0

@onready var rotation_speed = 2 * PI * rotation_per_second
@onready var health = max_health
@onready var shooting_speed = 1.0 / bullets_per_second
const HOOK_COOLDOWN = 1.0

var _reloading = false
var _reloading_hook = false

var thrust_intensity :
	get: return mass * max_speed / time_to_max_speed

var brake_intensity:
	get: return mass * max_speed / time_to_stop

@onready var flammes = $Flammes
@onready var sfx = $SFX
@onready var turret_control = $Turret/TurretControl
@onready var turret = $Turret
@onready var turret_nozzle = $Turret/TurretControl/Nozzle

func _shoot():
	if _reloading:
		return

	Events.emit_signal("shoot", global_position, global_rotation, linear_velocity)
	
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
	_torque()
	if (Input.is_action_pressed("brake")):
		_brake(state)
	else:
		_thrust(state)
	_custom_set_rotation()
		
func _thrust(state):
	var intensity = Input.get_axis("decelerate", "accelerate")
	var thrust = intensity * thrust_intensity * Vector2.from_angle(rotation)
	if linear_velocity.length() >= max_speed:
		# maintain max speed but change direction
		thrust = thrust - (linear_velocity.normalized() * thrust.length())
	state.apply_central_force(thrust)
	if intensity:
		flammes.visible = true
		sfx.play()
	else:
		flammes.visible = false
		sfx.stop()
	
func _torque():
	var intensity = Input.get_axis("turn_left", "turn_right")
	angular_velocity = rotation_speed * intensity

func _brake(state):
	if linear_velocity.length() > 10:
		state.apply_central_force(- brake_intensity * linear_velocity.normalized())
	elif linear_velocity.length() > 0:
		linear_velocity = linear_velocity.move_toward(Vector2.ZERO, 5)

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
