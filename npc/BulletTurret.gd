extends "res://npc/AbstractTurret.gd"

@export_range(0.0, 100.0) var bullet_spread = 0.0

var bullet_spread_angle:
	get: return (bullet_spread / 100) * PI / 2

const bullet_type_scene = {
	TurretType.ENEMY: preload("res://bullet/EnemyBullet.tscn"),
	TurretType.ALLY: preload("res://bullet/PlayerBullet.tscn"),
}

var laser = preload("res://laser/Laser.tscn")

@export_range(50.0,1000.0,50.0,"or_greater") var bullet_speed : float = 500.0


func _set_rotation_target():
	pass

func _on_shoot():
	
	var shooter_velocity = Helpers.get_velocity(shooter)
	var imprecision = randf_range(-bullet_spread_angle, bullet_spread_angle)
	var shooting_angle = global_rotation + imprecision
	
	var new_bullet = bullet_type_scene[turret_type].instantiate()
	new_bullet.init(nozzle.global_position, shooting_angle, shooter_velocity, bullet_speed)
