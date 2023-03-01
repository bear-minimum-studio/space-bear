@tool
extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

@export_range(0.0, 500.0, 10.0, "or_greater") var turret_range: float = 250.0 :
	set(new_turret_range):
		turret_range = new_turret_range
		if collision_shape_2d != null:
			collision_shape_2d.shape.radius = turret_range
		queue_redraw()
		
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

@export_range(0.1,10.0,0.1,"or_greater") var rotation_speed = 5.0

@export_range(50.0,1000.0,50.0,"or_greater") var bullet_speed : float = 500.0

@export_range(0.5,50.0) var bullets_per_second = 5.0
@onready var shooting_speed = 1.0 / bullets_per_second
var _reloading = false

@onready var nozzle = $Nozzle

@onready var rotation_target: float = global_rotation

var target : Node2D = null
var shooter : PhysicsBody2D = null

func init(new_shooter: PhysicsBody2D) -> void:
	shooter = new_shooter

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	_set_target()
	_set_rotation_target()
	global_rotation = lerp_angle(global_rotation, rotation_target, rotation_speed * delta)
	
	if target != null:
		shoot()

func _set_target():
	var bodies: Array[Node2D] = get_overlapping_bodies()
	var potential_targets = bodies.filter(func(body): return body.is_in_group(bullet_target_mapping[bullet_type]))
	target = Helpers.find_nearest_node(get_parent(), potential_targets)
	
func _set_rotation_target():
	if(shooter == null):
		return
		
	if target == null:
		rotation_target = shooter.global_rotation
		return
	
	var direction_to_target = (target.global_position - global_position).normalized()
	var shooter_velocity = Helpers.get_velocity(shooter)
	var target_velocity = Helpers.get_velocity(target)
	var correction = (target_velocity - shooter_velocity) / bullet_speed
	var shooting_direction = direction_to_target + correction
	rotation_target = shooting_direction.angle()

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
