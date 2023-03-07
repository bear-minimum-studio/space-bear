extends "res://weapons/projectiles/laser/Laser.gd"

func _hit(area_or_body):
	var health_system = HealthSystem.heal_health_system(area_or_body)
