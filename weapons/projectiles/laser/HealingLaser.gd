extends "res://weapons/projectiles/laser/Laser.gd"

func _hit(area_or_body):
	var health_system = area_or_body.find_child("HealthSystem")
	if health_system != null:
		health_system.heal()
