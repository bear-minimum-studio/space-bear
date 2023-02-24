extends Area2D

@export_range(0.5,50.0) var bullets_per_second = 5.0

enum BulletType { ENEMY, ALLY }
@export var bullet_type: BulletType= BulletType.ENEMY

@onready var shooting_speed = 1.0 / bullets_per_second
var _reloading = false

const bullet_type_mapping = {
	BulletType.ENEMY: "enemy_shoot",
	BulletType.ALLY: "shoot"
}

func shoot_towards(shooter: Node2D, body: Node2D):
	self.look_at(body.global_position)

	if _reloading:
		return

	Events.emit_signal(bullet_type_mapping[bullet_type], shooter.global_position, self.global_rotation, shooter.velocity)
	
	_reloading = true
	await get_tree().create_timer(shooting_speed).timeout
	_reloading = false
