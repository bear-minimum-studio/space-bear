class_name Utils

extends Node2D

# Second argument is array of nodes. Can't type it properly though,
# because sometimes it is Node2D and sometimes Node
func find_nearest_node(reference: Node2D, other_nodes: Array):
	var nearest = null
	var distance = null
	for current_node in other_nodes:
		var current_distance = reference.global_position.distance_to(current_node.global_position)
		if distance == null:
			nearest = current_node
			distance = current_distance
		elif current_distance < distance:
			nearest = current_node
			distance = current_distance

	return nearest

func get_velocity(node: PhysicsBody2D) -> Vector2:
	if node is RigidBody2D:
		return node.linear_velocity
	elif node is CharacterBody2D:
		return node.velocity
	elif node is StaticBody2D:
		return node.constant_linear_velocity
	else:
		return Vector2.ZERO

func angle_to_trigonometry_range(angle: float):
	return fposmod(angle - PI, 2 * PI) - PI

func get_screen_center():
	return get_viewport_rect().size / 2

