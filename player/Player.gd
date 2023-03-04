extends RigidBody2D
class_name Player

signal shoot_grappling_hook

@export_range(0.0,500.0,5.0,"or_greater") var max_speed = 200.0
@export_range(0.0,3.0,0.05,"or_greater") var time_to_max_speed = 1.0
@export_range(0.0,3.0,0.05,"or_greater") var time_to_stop = 0.7
@export_range(0.0,4.0,0.1,"or_greater") var rotation_per_second = 0.7

@onready var rotation_speed = 2 * PI * rotation_per_second

var thrust_intensity :
	get: return mass * max_speed / time_to_max_speed

var brake_intensity:
	get: return mass * max_speed / time_to_stop

@onready var flammes = $Flammes
@onready var sfx = $SFX
@onready var turret = $Turrets/Turret
@onready var p2_turret_control = $P2Turret/P2TurretControl
@onready var p2_turret = $P2Turret
@onready var health_system = $HealthSystem
@onready var hurt_animation = $HurtAnimation
@onready var selection_zone = $SelectionZone
@onready var p_2_turret_control = $P2Turret/P2TurretControl

func _ready():
	var turrets = $Turrets.get_children()
	for auto_turret in turrets:
		auto_turret.init(self)

func _shoot():
	turret.shoot()

func _custom_set_rotation():
	p2_turret.rotation = -self.rotation

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

func _on_health_system_hp_changed(health, max_health):
	Events.emit_signal("player_hp_changed", health, max_health)
	hurt_animation.animate_hurt($Player)

func _input(event):
	if event.is_action_pressed("upgrade"):
		_upgrade_selected_ship()
	if event.is_action_pressed("follow_me"):
		_follow_me()

func _follow_me():
	var selected_ship = selection_zone.current_selection
	if selected_ship == null:
		return

	if selected_ship.has_method("follow_player"):
		selected_ship.follow_player(self)

func _upgrade_selected_ship():
	var selected_ship = selection_zone.current_selection
	if selected_ship == null:
		return
	
	var price = ShipCatalog.catalog.get_current_ship_price()
	if FlockResources.get_resources() < price:
		return
	FlockResources.spend_resource(price)
	
	if selected_ship.has_method("upgrade"):
		selected_ship.upgrade()

func _on_health_system_dead():
	Events.dead_ship.emit(self)

func _on_p_2_turret_control_nozzle_shoot_grappling_hook(global_player_position, global_player_rotation):
	shoot_grappling_hook.emit(global_player_position, global_player_rotation)
