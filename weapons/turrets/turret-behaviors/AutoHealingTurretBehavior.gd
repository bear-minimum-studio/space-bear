extends "res://weapons/turrets/turret-behaviors/AutoTurretBehavior.gd"

func _set_target():
	if turret.shooter == null:
		return
	
	if shoot_target != null:
		var health_system = HealthSystem.get_health_system(shoot_target)

		var distance_to_target = turret.shooter.global_position.distance_to(shoot_target.global_position)
		if distance_to_target < turret.turret_range and health_system.is_hurt():
			return

	var bodies: Array[Node2D] = turret.get_overlapping_bodies()
	var potential_targets = bodies.filter(
		func(body):
			if not body.is_in_group("ally"):
				return false
			
			if body == turret.shooter:
				return false

			var health_system = HealthSystem.get_health_system(body)
			if health_system == null:
				return false

			if health_system.is_hurt():
				return true

			return false
	)
	shoot_target = Helpers.find_nearest_node(turret.shooter, potential_targets)
