extends Area2D

@export var targets_group = "enemy"

enum BulletType { ENEMY, ALLY }
@export var bullet_type: BulletType= BulletType.ENEMY
const bullet_type_mapping = {
	BulletType.ENEMY: "enemy_shoot",
	BulletType.ALLY: "shoot"
}

const TRUCQUIARROSE = PI/24

@export_range(0.5,50.0) var bullets_per_second = 5.0
@onready var shooting_speed = 1.0 / bullets_per_second
var _reloading = false

@onready var nozzle = $Nozzle

func _physics_process(_delta):
	var bodies: Array[Node2D] = self.get_overlapping_bodies()
	var potential_targets = bodies.filter(func(body): return body.is_in_group(targets_group))

	var nearest_body = Helpers.find_nearest_node(self.get_parent(), potential_targets)
	if nearest_body != null:
		self.shoot_towards(self.get_parent(), nearest_body)
	else:
		self.global_rotation = get_parent().global_rotation


func shoot_towards(shooter: Node2D, body: Node2D):
	self.look_at(body.global_position)

	if _reloading:
		return
	
	var shooter_velocity
	if shooter is RigidBody2D:
		shooter_velocity = shooter.linear_velocity
	else:
		shooter_velocity = shooter.velocity
	
	var imprecision = randf_range(-TRUCQUIARROSE, TRUCQUIARROSE)

	Events.emit_signal(bullet_type_mapping[bullet_type], nozzle.global_position, self.global_rotation + imprecision, shooter_velocity)
	
	_reloading = true
	await get_tree().create_timer(shooting_speed).timeout
	_reloading = false
