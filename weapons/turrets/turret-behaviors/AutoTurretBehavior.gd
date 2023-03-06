extends "res://weapons/turrets/turret-behaviors/AbstractTurretBehavior.gd"

const turret_target_mapping = {
	Allegiance.Allegiance.ENEMY: "ally",
	Allegiance.Allegiance.ALLY: "enemy"
}

var shoot_target : PhysicsBody2D = null

func _process(delta):
	super._process(delta)
	_set_rotation_target()
	if shoot_target != null and turret._is_in_angle_range(turret.rotation_target):
		turret.shoot()

func _set_target():
	if turret.shooter == null:
		return
	
	if shoot_target != null and turret.shooter.global_position.distance_to(shoot_target.global_position) < turret.turret_range:
		return
	
	var bodies: Array[Node2D] = turret.get_overlapping_bodies()
	var potential_targets = bodies.filter(func(body): return body.is_in_group(turret_target_mapping[turret.turret_allegiance]))
	shoot_target = Helpers.find_nearest_node(turret.shooter, potential_targets)
	
func _set_rotation_target():
	if turret == null or turret.shooter == null:
		return
	
	_set_target()
	if shoot_target == null:
		turret.rotation_target = turret.default_rotation
		return
	
	turret.rotation_target = turret._compute_shooting_direction(shoot_target)
