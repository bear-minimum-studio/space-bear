extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
		
@export_range(0.0, 100.0) var bullet_spread = 0.0

var bullet_spread_angle:
	get: return (bullet_spread / 100) * PI / 2

enum BulletType { ENEMY, ALLY }
@export var bullet_type: BulletType= BulletType.ENEMY

const bullet_target_mapping = {
	BulletType.ENEMY: "flock",
	BulletType.ALLY: "enemy"
}

const bullet_type_scene = {
	BulletType.ENEMY: preload("res://bullet/EnemyBullet.tscn"),
	BulletType.ALLY: preload("res://bullet/PlayerBullet.tscn"),
}

@export_range(0, PI, PI/32) var rotation_range: float = PI
@export_range(0.1,10.0,0.1,"or_greater") var rotation_speed = 5.0

@export_range(50.0,1000.0,50.0,"or_greater") var bullet_speed : float = 500.0

@export_range(0.5,50.0) var bullets_per_second = 5.0
@onready var shooting_speed = 1.0 / bullets_per_second
var _reloading = false

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

func init(new_shooter: PhysicsBody2D) -> void:
	shooter = new_shooter

func _physics_process(delta):
	_set_rotation_target()
	rotation = lerp_angle(rotation, _clamp_to_angle_range(rotation_target), rotation_speed * delta)
	
func _set_rotation_target():
	pass

func shoot():
	if _reloading:
		return
	
	var shooter_velocity = Helpers.get_velocity(shooter)
	var imprecision = randf_range(-bullet_spread_angle, bullet_spread_angle)
	var shooting_angle = global_rotation + imprecision
	
	var new_bullet = bullet_type_scene[bullet_type].instantiate()
	new_bullet.init(nozzle.global_position, shooting_angle, shooter_velocity, bullet_speed)
	
	_reloading = true
	await get_tree().create_timer(shooting_speed).timeout
	_reloading = false
