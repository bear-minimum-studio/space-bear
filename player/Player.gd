extends RigidBody2D
class_name Player

signal shoot_grappling_hook

@export_range(0.0,500.0,5.0,"or_greater") var max_speed = 300.0
@export_range(0.0,3.0,0.05,"or_greater") var time_to_max_speed = 0.7
@export_range(0.0,3.0,0.05,"or_greater") var time_to_stop = 0.5
@export_range(0.0,4.0,0.1,"or_greater") var rotation_per_second = 2.0
@export_range(0.0,0.3,0.01) var rotation_dead_zone = 0.05
@export_range(0.01,1.5) var rotation_damping_zone = 0.5
@export var remove_inertia = true

@onready var rotation_speed = 2 * PI * rotation_per_second

var thrust_intensity :
	get: return mass * max_speed / time_to_max_speed

var brake_intensity:
	get: return mass * max_speed / time_to_stop

var current_direction: Vector2 = Vector2.ZERO

@onready var sfx = $SFX
@onready var turret = $Turrets/Turret
@onready var health_system = $HealthSystem
@onready var hurt_animation = $HurtAnimation
@onready var selection_zone = $SelectionZone
@onready var player_sprite = $Player

@onready var flammes_right = $FlammesRight
@onready var flammes_left = $FlammesLeft
@onready var flammes_up = $FlammesUp
@onready var flammes_down = $FlammesDown
@onready var flammes = {flammes_down: [0.0], flammes_right: [-PI/2], flammes_up: [-PI,PI], flammes_left: [PI/2]}
const flamme_overlap_angle = 5 * PI / 9

func _ready():
	var turrets = $Turrets.get_children()
	for auto_turret in turrets:
		auto_turret.init(self)

func _shoot():
	turret.shoot()

func _integrate_forces(state):
	_torque()
	if (Input.is_action_pressed("brake")):
		_brake(state)
	else:
		_thrust(state)

func _deactivate_flammes():
	flammes_down.visible = false
	flammes_up.visible = false
	flammes_right.visible = false
	flammes_left.visible = false

func _activate_flammes(direction: Vector2):
	var relative_thrust_angle = Helpers.angle_to_trigonometry_range(direction.angle() - self.rotation)
	var min_acceptable_angle = relative_thrust_angle - flamme_overlap_angle/2
	var max_acceptable_angle = relative_thrust_angle + flamme_overlap_angle/2
	for f in flammes:
		f.visible = false
		for flamme_angle in flammes[f]:
			if (flamme_angle >= min_acceptable_angle) and (flamme_angle <= max_acceptable_angle):
				f.visible = true

func _thrust(state):
	var direction = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	var thrust = thrust_intensity * direction
	if linear_velocity.length() >= max_speed:
		# maintain max speed but change direction
		thrust = thrust - (linear_velocity.normalized() * thrust.length())
	state.apply_central_force(thrust)
	if remove_inertia:
		_compensate_inertia(state)
	
	if direction.length():
		_activate_flammes(direction)
		sfx.play()
	else:
		_deactivate_flammes()
		sfx.stop()

func _compensate_inertia(state):
	var direction = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	if direction.length():
		var orthonormal_velocity = linear_velocity.project(direction.orthogonal())
		var thrust = - thrust_intensity * orthonormal_velocity / max_speed
		if thrust:
			state.apply_central_force(thrust)

## return a scaling coefficient depending on how much the ship has to rotate
## In dead zone -> no rotation
## in damping zone -> slow rotation
## out of damping zone -> scale with angle of rotation
func _rotation_damping(remainder_angle: float) -> float:
	var angle = abs(remainder_angle)
	if InputMode.is_controller() and (angle < rotation_dead_zone):
		return 0
	if angle < rotation_damping_zone:
		return 1 - (rotation_damping_zone - angle) / rotation_damping_zone
	return 1 + (angle - rotation_damping_zone) / PI

func _torque():
	var intensity = 0
	if InputMode.is_mouse():
		intensity = 1
		current_direction = get_viewport().get_mouse_position() - get_global_transform_with_canvas().origin
	elif InputMode.is_controller():
		var direction = Input.get_vector("look_left", "look_right", "look_up", "look_down")
		intensity = direction.length()
		if intensity > 0:
			current_direction = direction

	var remainder_angle = Helpers.angle_to_trigonometry_range(current_direction.angle() - self.global_rotation)
	var rotation_sign = sign(remainder_angle)
	self.angular_velocity = rotation_sign * rotation_speed * intensity * _rotation_damping(remainder_angle)


func _brake(state):
	if linear_velocity.length() > 10:
		state.apply_central_force(- brake_intensity * linear_velocity.normalized())
	elif linear_velocity.length() > 0:
		linear_velocity = linear_velocity.move_toward(Vector2.ZERO, 5)

func _physics_process(_delta):
	if (Input.is_action_pressed("fire")):
		_shoot()

func _on_health_system_hp_changed(health, max_health, difference):
	if difference == 0:
		return
	elif difference > 0:
		hurt_animation.animate_heal(player_sprite)
	else:
		hurt_animation.animate_hurt(player_sprite)
	Events.emit_signal("player_hp_changed", health, max_health)

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
