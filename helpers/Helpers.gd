class_name Helpers

extends Node2D

# Second argument is array of nodes. Can't type it properly though,
# because sometimes it is Node2D and sometimes Node
static func find_nearest_node(reference: Node2D, other_nodes: Array):
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

static func set_parent_material_to_children(parent: Control, value :bool):
	for child in parent.get_children(true):
		if not(child is Control):
			continue
		child.use_parent_material = value
		Helpers.set_parent_material_to_children(child, value)

static func get_velocity(node: PhysicsBody2D) -> Vector2:
	if node is RigidBody2D:
		return node.linear_velocity
	elif node is CharacterBody2D:
		return node.velocity
	elif node is StaticBody2D:
		return node.constant_linear_velocity
	else:
		return Vector2.ZERO

static func angle_to_trigonometry_range(angle: float):
	return fposmod(angle - PI, 2 * PI) - PI

static func get_screen_center(any_node: Node):
	return any_node.get_viewport_rect().size / 2

static func set_mouse_position(any_node: Node, mouse_position: Vector2):
	any_node.get_viewport().warp_mouse(mouse_position)
