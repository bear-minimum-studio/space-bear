@tool
extends "res://npc/Turret.gd"

@export_range(0.0, 500.0, 10.0, "or_greater") var turret_range: float = 250.0 :
	set(new_turret_range):
		turret_range = new_turret_range
		if collision_shape_2d != null:
			collision_shape_2d.shape.radius = turret_range
		queue_redraw()

var target : Node2D = null

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	super._physics_process(delta)
	if target != null:
		shoot()

func _set_target():
	if shooter == null:
		return
	
	if target != null and shooter.global_position.distance_to(target.global_position) < turret_range:
		return
	
	var bodies: Array[Node2D] = get_overlapping_bodies()
	var potential_targets = bodies.filter(func(body): return body.is_in_group(bullet_target_mapping[bullet_type]))
	target = Helpers.find_nearest_node(shooter, potential_targets)
	
func _set_rotation_target():
	if(shooter == null):
		return
	
	_set_target()
	if target == null:
		rotation_target = default_rotation
		return
	
	var direction_to_target = (target.global_position - global_position).normalized()
	var shooter_velocity = Helpers.get_velocity(shooter)
	var target_velocity = Helpers.get_velocity(target)
	var correction = (target_velocity - shooter_velocity) / bullet_speed
	var shooting_direction = direction_to_target + correction
	rotation_target = shooting_direction.angle() - shooter.global_rotation
