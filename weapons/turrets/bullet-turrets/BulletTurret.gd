extends "res://weapons/turrets/AbstractTurret.gd"

@export_range(0.0, 100.0) var bullet_spread = 0.0
@export_range(50.0,1000.0,50.0,"or_greater") var bullet_speed : float = 500.0
@export_range(1, 30) var bullet_damage = 1
@export_range(0.1, 4.0, 0.1) var bullet_size = 1.0

var bullet_spread_angle:
	get: return (bullet_spread / 100) * PI / 2

const bullet_type_scene = {
	Allegiance.Allegiance.ENEMY: preload("res://weapons/projectiles/bullet/EnemyBullet.tscn"),
	Allegiance.Allegiance.ALLY: preload("res://weapons/projectiles/bullet/PlayerBullet.tscn"),
}

func _on_shoot():
	var shooter_velocity = Helpers.get_velocity(shooter)
	var imprecision = randf_range(-bullet_spread_angle, bullet_spread_angle)
	var shooting_angle = global_rotation + imprecision

	var new_bullet = bullet_type_scene[turret_allegiance].instantiate()
	new_bullet.init(nozzle.global_position, shooting_angle, shooter_velocity, bullet_speed, bullet_damage, bullet_size)
