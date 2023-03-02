extends Area2D

@onready var collision_shape_2d = $CollisionShape2D
		
@export_range(0.0, 100.0) var bullet_spread = 0.0

var bullet_spread_angle:
	get: return (bullet_spread / 100) * PI / 2

enum BulletType { ENEMY, ALLY }
@export var bullet_type: BulletType= BulletType.ENEMY

const bullet_type_mapping = {
	BulletType.ENEMY: "enemy_shoot",
	BulletType.ALLY: "shoot"
}

const bullet_target_mapping = {
	BulletType.ENEMY: "flock",
	BulletType.ALLY: "enemy"
}


@export_range(0, PI, PI/32) var rotation_range: float = PI
@export_range(0.1,10.0,0.1,"or_greater") var rotation_speed = 5.0

@export_range(50.0,1000.0,50.0,"or_greater") var bullet_speed : float = 500.0

@export_range(0.5,50.0) var bullets_per_second = 5.0
@onready var shooting_speed = 1.0 / bullets_per_second
var _reloading = false

@onready var nozzle = $Nozzle

@onready var rotation_target: float = 0:
	set(new_rotation_target):
		new_rotation_target = fmod(new_rotation_target, PI)
		new_rotation_target = max(min(new_rotation_target, rotation_range), -rotation_range)
		rotation_target = new_rotation_target
		

var shooter : PhysicsBody2D = null

func init(new_shooter: PhysicsBody2D) -> void:
	shooter = new_shooter

func _physics_process(delta):
	_set_rotation_target()
	rotation = lerp_angle(rotation, rotation_target, rotation_speed * delta)
	
func _set_rotation_target():
	pass

func shoot():
	if _reloading:
		return
	
	var shooter_velocity = Helpers.get_velocity(shooter)
	var imprecision = randf_range(-bullet_spread_angle, bullet_spread_angle)
	var shooting_angle = global_rotation + imprecision
	Events.emit_signal(bullet_type_mapping[bullet_type], nozzle.global_position, shooting_angle, shooter_velocity, bullet_speed)
	
	_reloading = true
	await get_tree().create_timer(shooting_speed).timeout
	_reloading = false
