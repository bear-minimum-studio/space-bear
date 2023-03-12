extends "res://npc/ship-behaviors/AbstractShipBehavior.gd"

class_name SquadronShipBehavior

var squadron: Squadron

var avoidance_velocity: Vector2
var alignment_velocity: Vector2
var cohesion_velocity: Vector2
var squadron_target_velocity: Vector2
var combined_velocity: Vector2
var target_velocity: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float):
	if squadron == null:
		return
	get_parent().movement_target = _compute_next_target_position()
	queue_redraw()

func add_to_squadron(squadron_id: String):
	squadron = WorldReference.current_world.squadrons_handler.get_or_create_squadron(squadron_id)
	squadron.add_ship(get_parent())

func _compute_next_target_position():
	var proximity_vector = Vector2.ZERO
	for other_ship in squadron.ships:
		if other_ship == null or other_ship == get_parent():
			continue
		var vector_from_other_ship = get_parent().global_position - other_ship.global_position
		var distance = vector_from_other_ship.length()
		if distance < squadron.avoidance_range:
			var avoidance_vector: Vector2
			if vector_from_other_ship != Vector2.ZERO:
				avoidance_vector = (squadron.avoidance_range - vector_from_other_ship.length()) * vector_from_other_ship.normalized()
			else:
				avoidance_vector = squadron.avoidance_range * Vector2.from_angle(randf_range(-PI, PI))
			proximity_vector += avoidance_vector
	
	avoidance_velocity = squadron.avoidance_factor * proximity_vector
	alignment_velocity = squadron.alignment_factor * (squadron.velocity - Helpers.get_velocity(get_parent()))
	cohesion_velocity = squadron.cohesion_factor * (squadron.global_position - get_parent().global_position)
	squadron_target_velocity = squadron.squadron_target_factor * (squadron.movement_target - squadron.global_position)
	combined_velocity = (avoidance_velocity + alignment_velocity + cohesion_velocity + squadron_target_velocity) / (squadron.avoidance_factor + squadron.alignment_factor + squadron.cohesion_factor + squadron.squadron_target_factor)
	target_velocity = squadron.velocity_factor * combined_velocity

	return get_parent().global_position + target_velocity

func _draw():
	if get_parent().debug_enabled:
		draw_line(Vector2.ZERO, avoidance_velocity.rotated(-get_parent().global_rotation), Color.RED, 2,0)
		draw_line(Vector2.ZERO, alignment_velocity.rotated(-get_parent().global_rotation), Color.BROWN, 2,0)
		draw_line(Vector2.ZERO, cohesion_velocity.rotated(-get_parent().global_rotation), Color.GREEN, 2,0)
		draw_line(Vector2.ZERO, squadron_target_velocity.rotated(-get_parent().global_rotation), Color.YELLOW, 2,0)
