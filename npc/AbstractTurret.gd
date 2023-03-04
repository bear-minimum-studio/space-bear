extends Area2D


enum TurretType { ENEMY, ALLY }
@export var turret_type: TurretType = TurretType.ENEMY

@export_range(0, PI, PI/32) var rotation_range: float = PI
@export_range(0.1,10.0,0.1,"or_greater") var rotation_speed = 5.0

@export_range(0.5,50.0) var shots_per_second = 5.0
@onready var shooting_speed = 1.0 / shots_per_second
var _reloading = false

@onready var collision_shape_2d = $CollisionShape2D
@onready var nozzle = $Nozzle
@onready var default_rotation = rotation
@onready var rotation_target: float = default_rotation

var shooter : PhysicsBody2D = null

# Clamps given angle to angle range:
#   min : default_rotation - rotation_range
#   max : default_rotation + rotation_range
func _clamp_to_angle_range(angle: float) -> float:
	var clamped_angle = fmod(angle - default_rotation, PI)
	clamped_angle = clamp(clamped_angle, -rotation_range, rotation_range) + default_rotation
	return clamped_angle

# Checks if given angle is in angle range:
#   min : default_rotation - rotation_range
#   max : default_rotation + rotation_range
func _is_in_angle_range(angle: float) -> bool:
	var clamped_angle = fmod(angle - default_rotation, PI)
	return -rotation_range <= clamped_angle and clamped_angle <= rotation_range

func _physics_process(delta):
	_set_rotation_target()
	rotation = lerp_angle(rotation, _clamp_to_angle_range(rotation_target), rotation_speed * delta)
	
func _set_rotation_target():
	pass

# Overload with shooting behavior
func _on_shoot():
	pass

func init(new_shooter: PhysicsBody2D) -> void:
	shooter = new_shooter

func shoot():
	if _reloading:
		return

	_on_shoot()

	_reloading = true
	await get_tree().create_timer(shooting_speed).timeout
	_reloading = false
