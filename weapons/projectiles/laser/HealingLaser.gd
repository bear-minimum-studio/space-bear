extends "res://weapons/projectiles/laser/Laser.gd"

func _hit(area_or_body):
	HealthSystem.heal_health_system(area_or_body, damage_or_heal)
