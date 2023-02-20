extends RigidBody2D

signal shoot

const THRUST = 200.0
const THRUST_FRICTION = 0.5

@export_range(0.0,10.0,0.1) var rotation_speed :float = 2.0
@export_range(1,100) var max_health : int = 10
@export_range(0.5,50.0) var bullets_per_second = 5.0

@onready var health = max_health
@onready var shooting_speed = 1.0 / bullets_per_second

var _reloading = false

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
	angular_velocity = rotation_speed * intensity


func _physics_process(_delta):
	if (Input.is_action_pressed("fire")):
		_shoot()

func _on_turret_control_shoot():
	emit_signal("shoot", turret_control.global_position, turret_control.global_rotation, linear_velocity)

func on_hit():
	health -= 1
	Events.emit_signal("player_hp_changed", health, max_health)
