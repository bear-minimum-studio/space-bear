extends "res://weapons/turrets/turret-behaviors/AutoTurretBehavior.gd"

func _set_target():
	if turret.shooter == null:
		return
	
	if shoot_target != null:
		var healing_system = shoot_target.find_child('HealthSystem')

		var distance_to_target = turret.shooter.global_position.distance_to(shoot_target.global_position)
		if distance_to_target < turret.turret_range and healing_system.health < healing_system.max_health:
			return

	var bodies: Array[Node2D] = turret.get_overlapping_bodies()
	var potential_targets = bodies.filter(
		func(body):
			if not body.is_in_group("flock"):
				return false
			var healing_system = body.find_child('HealthSystem')
			if healing_system == null:
				return false
			if healing_system.health != healing_system.max_health:
				return true
			return false
	)
	shoot_target = Helpers.find_nearest_node(turret.shooter, potential_targets)
